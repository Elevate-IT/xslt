<xsl:stylesheet
  version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:eit="http://www.elevate-it.be"
  xmlns:ns0="www.boltrics.nl/materialmasterdata:v1.00"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all"
  expand-text="yes">
  
  <xsl:output method="xml" indent="yes" encoding="utf-8"/>
  
  <!-- ============================================================
       PARAMETERS  (can be overridden by the calling process)
       ============================================================ -->
  
  <!-- Preferred language for primary Description field -->
  <xsl:param name="primaryLang"   as="xs:string" select="'EN'"/>
  <!-- Fallback language if primary not found -->
  <xsl:param name="fallbackLang"  as="xs:string" select="'NL'"/>
  
  <!-- ============================================================
       NAMED FUNCTIONS
       ============================================================ -->
  
  <!-- Strip leading zeros from a numeric string (e.g. SAP MATNR) -->
  <xsl:function name="eit:stripLeadingZeros" as="xs:string">
    <xsl:param name="val" as="xs:string"/>
    <xsl:value-of select="
      if (matches($val, '^0+$')) then '0'
      else replace($val, '^0+', '')
                    "/>
  </xsl:function>
  
  <!-- Build xs:dateTime from SAP CREDAT (YYYYMMDD) and CRETIM (HHMMSS) -->
  <xsl:function name="eit:sapDateTime" as="xs:string">
    <xsl:param name="date" as="xs:string"/>  <!-- YYYYMMDD -->
    <xsl:param name="time" as="xs:string"/>  <!-- HHMMSS   -->
    <xsl:value-of select="concat(
        substring($date,1,4), '-',
        substring($date,5,2), '-',
        substring($date,7,2), 'T',
        substring($time,1,2), ':',
        substring($time,3,2), ':',
        substring($time,5,2)
      )"/>
  </xsl:function>
  
  <!-- Map SAP language key to ISO 3-letter language code -->
  <xsl:function name="eit:sapLangToIso" as="xs:string">
    <xsl:param name="sapLang" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$sapLang = 'EN'">ENU</xsl:when>
      <xsl:when test="$sapLang = 'DE'">DEU</xsl:when>
      <xsl:when test="$sapLang = 'FR'">FRA</xsl:when>
      <xsl:when test="$sapLang = 'NL'">NLD</xsl:when>
      <xsl:when test="$sapLang = 'ES'">ESP</xsl:when>
      <xsl:otherwise>{$sapLang}</xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- Retrieve a Z1AUSPM characteristic value by charact name -->
  <xsl:function name="eit:getCharact" as="xs:string">
    <xsl:param name="maram"   as="element()"/>
    <xsl:param name="charact" as="xs:string"/>
    <xsl:value-of select="($maram/Z1AUSPM[CHARACT = $charact]/VALUE_CHAR)[1]"/>
  </xsl:function>
  
  <!-- ============================================================
       ROOT TEMPLATE
       ============================================================ -->
  <xsl:template match="/">
    <xsl:apply-templates select="/ZMATMAS05/IDOC"/>
  </xsl:template>
  
  <!-- ============================================================
       IDOC → Message
       ============================================================ -->
  <xsl:template match="IDOC">
    <ns0:Message>
      <ns0:Header>
        <xsl:call-template name="Header"/>
      </ns0:Header>
      <ns0:CustomerItems>
        <xsl:apply-templates select="E1MARAM"/>
      </ns0:CustomerItems>
    </ns0:Message>
  </xsl:template>
  
  <!-- ============================================================
       HEADER
       ============================================================ -->
  <xsl:template name="Header">
    <ns0:MessageID>{EDI_DC40/DOCNUM}</ns0:MessageID>
    
    <ns0:CreationDateTime>{eit:sapDateTime(
        xs:string(EDI_DC40/CREDAT),
        xs:string(EDI_DC40/CRETIM)
      )}</ns0:CreationDateTime>
    
    <ns0:ProcesAction>INSERT</ns0:ProcesAction>
    <ns0:FromTradingPartner>AGRISTO</ns0:FromTradingPartner>
  </xsl:template>
  
  <!-- ============================================================
       E1MARAM → CustomerItem
       ============================================================ -->
  <xsl:template match="E1MARAM">
    
    <!-- Resolve preferred long-text description (EN, fallback NL) -->
    <xsl:variable name="longTextEN"
      select="(E1MTXHM[SPRAS_ISO = $primaryLang]/E1MTXLM[TDFORMAT='*']/TDLINE)[1]"/>
    <xsl:variable name="longTextNL"
      select="(E1MTXHM[SPRAS_ISO = $fallbackLang]/E1MTXLM[TDFORMAT='*']/TDLINE)[1]"/>
    
    <xsl:variable name="shortTextEN"
      select="(E1MAKTM[SPRAS_ISO = $primaryLang]/MAKTX)[1]"/>
    
    <ns0:CustomerItem>
      <ns0:ExternalNo>{eit:stripLeadingZeros(xs:string(MATNR))}</ns0:ExternalNo>
      <ns0:No2>{eit:stripLeadingZeros(xs:string(MATNR))}</ns0:No2>
      
      <ns0:Description>
        <xsl:choose>
          <xsl:when test="$longTextEN != ''">
            <xsl:value-of select="$longTextEN"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$shortTextEN"/>
          </xsl:otherwise>
        </xsl:choose>
      </ns0:Description>
      
      <xsl:if test="$shortTextEN != ''">
        <ns0:Description2>{$shortTextEN}</ns0:Description2>
      </xsl:if>
      
      <ns0:SearchDescription>
        <xsl:choose>
          <xsl:when test="$longTextNL != ''">
            <xsl:value-of select="$longTextNL"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$longTextEN"/>
          </xsl:otherwise>
        </xsl:choose>
      </ns0:SearchDescription>
      
      <ns0:BaseUnitofMeasure>{MEINS}</ns0:BaseUnitofMeasure>
      <xsl:variable name="BaseUoM" select="MEINS"/>
      <ns0:OrderUnitofMeasure>{MEINS}</ns0:OrderUnitofMeasure>
      <ns0:UnitofMeasureatReceipt>{MEINS}</ns0:UnitofMeasureatReceipt>
      <ns0:UnitofMeasureatShipment>{MEINS}</ns0:UnitofMeasureatShipment>
      <ns0:UnitofMeasureatStorage>{MEINS}</ns0:UnitofMeasureatStorage>
      
      <!-- <ns0:ProductGroupCode>{MATKL}</ns0:ProductGroupCode> -->
      
      <!-- Customs tariff number from plant data -->
      <!-- <xsl:variable name="stawn" select="(E1MARCM/STAWN[normalize-space(.) != ''])[1]"/>
           <xsl:if test="$stawn">
           <ns0:TariffNo>{$stawn}</ns0:TariffNo>
           </xsl:if> -->
      
      <!-- Carrier type from WMS classification -->
      <xsl:variable name="carrierType" select="substring(replace(eit:getCharact(., 'Z_WMS_DRAGER_MATNR'), 'PAL_', ''), 1, 10)"/>
      <xsl:if test="$carrierType != ''">
        <ns0:CarrierTypeCodeReceipt>{$carrierType}</ns0:CarrierTypeCodeReceipt>
        <ns0:CarrierTypeCodeShipment>{$carrierType}</ns0:CarrierTypeCodeShipment>
      </xsl:if>
      
      <!-- DefaultCarrierQuantity from WMS classification Z_WMS_PALHOEVH -->
      <xsl:variable name="palQty" select="eit:getCharact(., 'Z_WMS_PALHOEVH')"/>
      <xsl:if test="$palQty != ''">
        <ns0:DefaultCarrierQuantity>{$palQty}</ns0:DefaultCarrierQuantity>
      </xsl:if>
      
      <ns0:Status>1</ns0:Status>
      <ns0:ConditionatReceipt>BEVROREN</ns0:ConditionatReceipt>
      <ns0:ConditionatShipment>BEVROREN</ns0:ConditionatShipment>
      <ns0:ConditionatStorage>BEVROREN</ns0:ConditionatStorage>
      <ns0:ReservationMethod>3</ns0:ReservationMethod> <!-- Expiration Date  -->
      <ns0:ReservationMethodCarrier>METHOD_8</ns0:ReservationMethodCarrier>
      <ns0:ShptCarrierCalcMethod>METHOD05</ns0:ShptCarrierCalcMethod>
      <ns0:ExtBatchNoMandatoryPost>1</ns0:ExtBatchNoMandatoryPost>
      <ns0:ExpirationDateMandatory>1</ns0:ExpirationDateMandatory>
      <ns0:ExtBatchNoEqualBatchNo>1</ns0:ExtBatchNoEqualBatchNo>
      
      <!-- ==================== UNITS OF MEASURE ==================== -->
      <xsl:if test="E1MARMM">
        <ns0:UnitOfMeasures>
          <xsl:apply-templates select="E1MARMM[MEINH = $BaseUoM]">
            <xsl:with-param name="maram" select="."/>
          </xsl:apply-templates>
        </ns0:UnitOfMeasures>
      </xsl:if>
      
      <!-- ==================== TRANSLATIONS ==================== -->
      <xsl:if test="E1MTXHM">
        <ns0:Translations>
          <xsl:apply-templates select="E1MTXHM"/>
        </ns0:Translations>
      </xsl:if>
      
      <!-- ==================== TAX DATA PER COUNTRY ==================== -->
      <!-- <xsl:if test="E1MLANM">
           <ns0:CustomerItemTaxDatas>
           <xsl:apply-templates select="E1MLANM">
           <xsl:with-param name="maram" select="."/>
           </xsl:apply-templates>
           </ns0:CustomerItemTaxDatas>
           </xsl:if> -->
           
     </ns0:CustomerItem>
  </xsl:template>
  
  <!-- ============================================================
       E1MARMM → UnitOfMeasure
       ============================================================ -->
  <xsl:template match="E1MARMM">
    <xsl:param name="maram" as="element()"/>
    
    <!-- Conversion factor: prefer UMREZ (numerator) when > 1, else UMREN (denominator) -->
    <ns0:UnitOfMeasure>
      <ns0:Code>{MEINH}</ns0:Code>
      
      <ns0:QtyperUnitofMeasure>{UMREZ div UMREN}</ns0:QtyperUnitofMeasure>
      
      <ns0:EANCode>{EAN11}</ns0:EANCode>
      
      <!-- Dimensions (0.000 when not provided) -->
      <xsl:if test="number(LAENG) != 0"><ns0:Length>{LAENG}</ns0:Length></xsl:if>
      <xsl:if test="number(BREIT) != 0"><ns0:Width>{BREIT}</ns0:Width></xsl:if>
      <xsl:if test="number(HOEHE) != 0"><ns0:Height>{HOEHE}</ns0:Height></xsl:if>
      <xsl:if test="number(VOLUM) != 0"><ns0:Cubage>{VOLUM}</ns0:Cubage></xsl:if>
      
      <!-- Weights -->
      <xsl:if test="number(BRGEW) != 0">
        <ns0:GrossWeight>{BRGEW}</ns0:GrossWeight>
      </xsl:if>
      <!-- NetWeight only available on base unit; take from MARAM NTGEW -->
      <xsl:if test="MEINH = $maram/MEINS and number($maram/NTGEW) != 0">
        <ns0:NetWeight>{$maram/NTGEW}</ns0:NetWeight>
      </xsl:if>
      
      <!-- Carrier info on the pallet UoM (PF = pallet) -->
      <xsl:variable name="carrierType"
        select="substring(replace(eit:getCharact($maram, 'Z_WMS_DRAGER_MATNR'), 'PAL_', ''), 1, 10)"/>
      <xsl:variable name="palQty"
        select="eit:getCharact($maram, 'Z_WMS_PALHOEVH')"/>
      <xsl:variable name="layers"
        select="eit:getCharact($maram, 'Z_WMS_LAYERS')"/>
      
      <xsl:if test="$carrierType != '' and (MEINH = $maram/MEINS)">
        <ns0:UnitOfMeasureCarriers>
          <ns0:UnitOfMeasureCarrier>
            <ns0:CarrierTypeCode>{$carrierType}</ns0:CarrierTypeCode>
            <xsl:if test="$palQty != ''">
              <ns0:QtyperUOMCode>{$palQty}</ns0:QtyperUOMCode>
            </xsl:if>
            <!-- QtyperLayer = palQty ÷ layers (integer division) -->
            <xsl:if test="$palQty != '' and $layers != '' and number($layers) != 0">
              <ns0:QtyperLayer>{xs:integer(number($palQty) idiv number($layers))}</ns0:QtyperLayer>
            </xsl:if>
          </ns0:UnitOfMeasureCarrier>
        </ns0:UnitOfMeasureCarriers>
      </xsl:if>
      
    </ns0:UnitOfMeasure>
  </xsl:template>
  
  <!-- ============================================================
       E1MTXHM → Translation
       ============================================================ -->
  <xsl:template match="E1MTXHM">
    <!-- Resolve matching long text for same language -->
    <xsl:variable name="longText"
      select="(E1MTXLM[TDFORMAT = '*']/TDLINE)[1]"/>
    
    <xsl:if test="$longText != ''">
      <ns0:Translation>
        <ns0:LanguageCode>{eit:sapLangToIso(SPRAS_ISO)}</ns0:LanguageCode>
        <ns0:Description>{substring($longText, 1, 50)}</ns0:Description>
      </ns0:Translation>
    </xsl:if>
  </xsl:template>
  
  <!-- ============================================================
       E1MLANM → CustomerItemTaxData
       ============================================================ -->
  <xsl:template match="E1MLANM">
    <xsl:param name="maram" as="element()"/>
    
    <xsl:variable name="stawn"
      select="(../E1MARCM/STAWN[normalize-space(.) != ''])[1]"/>
    <xsl:variable name="herkl"
      select="(../E1MARCM/HERKL[normalize-space(.) != ''])[1]"/>
    
    <ns0:CustomerItemTaxData>
      <ns0:CountryCode>{ALAND}</ns0:CountryCode>
      <xsl:if test="$stawn">
        <ns0:TariffNo>{$stawn}</ns0:TariffNo>
      </xsl:if>
      <xsl:if test="$herkl">
        <ns0:CountryofOriginCode>{$herkl}</ns0:CountryofOriginCode>
      </xsl:if>
    </ns0:CustomerItemTaxData>
  </xsl:template>
  
  <!-- ============================================================
       Z1AUSPM → Attribute
       Each Z1AUSPM classification characteristic becomes one Attribute
       ============================================================ -->
  <xsl:template match="Z1AUSPM">
    <!-- Truncate Code to 10 chars (schema maxLength) -->
    <xsl:variable name="code" select="substring(
        replace(xs:string(CHARACT), '_', ''), 1, 10
      )"/>
    <ns0:Attribute>
      <ns0:Code>{$code}</ns0:Code>
      <ns0:Description>{substring(xs:string(CHARACT_DESCR), 1, 50)}</ns0:Description>
      <ns0:Value>{xs:string(VALUE_CHAR)}</ns0:Value>
    </ns0:Attribute>
  </xsl:template>
  
</xsl:stylesheet>
