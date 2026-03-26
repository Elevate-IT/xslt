<xsl:stylesheet
  version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:eit="http://www.elevate-it.be"
  xmlns:ns0="www.boltrics.nl/materialmasterdata:v1.00"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="xs fn eit"
  expand-text="yes">
  
  <xsl:output method="xml" indent="yes" encoding="utf-8"/>
  
  <!-- ============================================================
       PARAMETERS  (can be overridden by the calling process)
       ============================================================ -->
  
  <!-- Preferred language for primary Description field -->
  <xsl:param name="primaryLang"   as="xs:string" select="'E'"/>
  <!-- Fallback language if primary not found -->
  <xsl:param name="fallbackLang"  as="xs:string" select="'N'"/>
  <!-- Preferred valuation area for UnitCost -->
  <xsl:param name="preferredBwkey" as="xs:string" select="'P101'"/>
  
  <!-- ============================================================
       VARIABLES — document-level shortcuts
       ============================================================ -->
  <xsl:variable name="idoc"     select="/ZMATMAS05/IDOC"/>
  <xsl:variable name="dc40"     select="$idoc/EDI_DC40"/>
  <xsl:variable name="maram"    select="$idoc/E1MARAM"/>
  
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
      <xsl:when test="$sapLang = 'E'">ENU</xsl:when>
      <xsl:when test="$sapLang = 'D'">DEU</xsl:when>
      <xsl:when test="$sapLang = 'F'">FRA</xsl:when>
      <xsl:when test="$sapLang = 'N'">NLD</xsl:when>
      <xsl:when test="$sapLang = 'S'">ESP</xsl:when>
      <xsl:when test="$sapLang = 'I'">ITA</xsl:when>
      <xsl:when test="$sapLang = 'P'">PTG</xsl:when>
      <xsl:otherwise>{$sapLang}</xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- Determine ProcesAction from MSGFN function code -->
  <xsl:function name="eit:procesAction" as="xs:string">
    <xsl:param name="msgfn" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$msgfn = '009'">INSERT</xsl:when>  <!-- original/create -->
      <xsl:when test="$msgfn = '005'">MODIFY</xsl:when>  <!-- change          -->
      <xsl:when test="$msgfn = '006'">DELETE</xsl:when>  <!-- delete          -->
      <xsl:otherwise>MODIFY</xsl:otherwise>               <!-- safe default    -->
    </xsl:choose>
  </xsl:function>
  
  <!-- Retrieve a Z1AUSPM characteristic value by charact name -->
  <xsl:function name="eit:getCharact" as="xs:string">
    <xsl:param name="maram"   as="element()"/>
    <xsl:param name="charact" as="xs:string"/>
    <xsl:value-of select="
      ($maram/Z1AUSPM[CHARACT = $charact]/VALUE_CHAR)[1]
                    "/>
  </xsl:function>
  
  <!-- ============================================================
       ROOT TEMPLATE
       ============================================================ -->
  <xsl:template match="/">
    <xsl:apply-templates select="$idoc"/>
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
    <!-- MessageID from IDoc document number -->
    <ns0:MessageID>{$dc40/DOCNUM}</ns0:MessageID>
    
    <!-- CreationDateTime: combine CREDAT + CRETIM -->
    <ns0:CreationDateTime>{eit:sapDateTime(
        xs:string($dc40/CREDAT),
        xs:string($dc40/CRETIM)
      )}</ns0:CreationDateTime>
    
    <!-- ProcesAction derived from E1MARAM MSGFN -->
    <ns0:ProcesAction>{eit:procesAction(xs:string($maram/MSGFN))}</ns0:ProcesAction>
    
    <!-- Trading partners -->
    <ns0:FromTradingPartner>{$dc40/SNDPRN}</ns0:FromTradingPartner>
    <ns0:ToTradingPartner>{$dc40/RCVPRN}</ns0:ToTradingPartner>
    
    <!-- CompanyName from Z_BRAND classification -->
    <xsl:variable name="brand" select="eit:getCharact($maram, 'Z_BRAND')"/>
    <xsl:if test="$brand != ''">
      <ns0:CompanyName>{$brand}</ns0:CompanyName>
    </xsl:if>
    
    <!-- UniqueMessageNumber from IDoc serial -->
    <ns0:UniqueMessageNumber>{$dc40/SERIAL}</ns0:UniqueMessageNumber>
  </xsl:template>
  
  <!-- ============================================================
       E1MARAM → CustomerItem
       ============================================================ -->
  <xsl:template match="E1MARAM">
    
    <!-- Resolve preferred long-text description (EN, fallback NL) -->
    <xsl:variable name="longTextEN"
      select="(E1MTXHM[TDSPRAS = $primaryLang]/E1MTXLM[TDFORMAT='*']/TDLINE)[1]"/>
    <xsl:variable name="longTextNL"
      select="(E1MTXHM[TDSPRAS = $fallbackLang]/E1MTXLM[TDFORMAT='*']/TDLINE)[1]"/>
    <xsl:variable name="shortTextEN"
      select="(E1MAKTM[SPRAS = $primaryLang]/MAKTX)[1]"/>
    
    <!-- Preferred valuation area for pricing; fallback to first available -->
    <xsl:variable name="mbew"
      select="(E1MBEWM[BWKEY = $preferredBwkey], E1MBEWM)[1]"/>
    
    <ns0:CustomerItem>
      
      <!-- Material number (leading zeros stripped) -->
      <ns0:No>{eit:stripLeadingZeros(xs:string(MATNR))}</ns0:No>
      
      <!-- Primary description: EN long text preferred -->
      <ns0:Description>
        <xsl:value-of select="
          if ($longTextEN != '') then $longTextEN
          else $shortTextEN
                        "/>
      </ns0:Description>
      
      <!-- SearchDescription: short text (E1MAKTM) -->
      <xsl:if test="$shortTextEN != ''">
        <ns0:SearchDescription>{$shortTextEN}</ns0:SearchDescription>
      </xsl:if>
      
      <!-- Description2: NL long text -->
      <xsl:if test="$longTextNL != ''">
        <ns0:Description2>{$longTextNL}</ns0:Description2>
      </xsl:if>
      
      <!-- Base unit of measure -->
      <ns0:BaseUnitofMeasure>{MEINS}</ns0:BaseUnitofMeasure>
      
      <!-- Blocked: true when MSTAE is filled (material status set) -->
      <ns0:Blocked>{if (normalize-space(MSTAE) != '' and MSTAE != '  ')
          then 'true' else 'false'}</ns0:Blocked>
      
      <!-- Material group → ProductGroupCode -->
      <xsl:if test="normalize-space(MATKL) != ''">
        <ns0:ProductGroupCode>{MATKL}</ns0:ProductGroupCode>
      </xsl:if>
      
      <!-- Customs tariff number from plant data -->
      <xsl:variable name="stawn" select="(E1MARCM/STAWN[normalize-space(.) != ''])[1]"/>
      <xsl:if test="$stawn">
        <ns0:TariffNo>{$stawn}</ns0:TariffNo>
      </xsl:if>
      
      <!-- Carrier type from WMS classification -->
      <xsl:variable name="carrierMatnr" select="eit:getCharact(., 'Z_WMS_DRAGER_MATNR')"/>
      <xsl:if test="$carrierMatnr != ''">
        <ns0:CarrierTypeCodeReceipt>{$carrierMatnr}</ns0:CarrierTypeCodeReceipt>
        <ns0:CarrierTypeCodeShipment>{$carrierMatnr}</ns0:CarrierTypeCodeShipment>
      </xsl:if>
      
      <!-- Unit cost: standard price from preferred valuation area -->
      <xsl:if test="$mbew/STPRS != '' and number($mbew/STPRS) != 0">
        <ns0:UnitCost>{$mbew/STPRS}</ns0:UnitCost>
      </xsl:if>
      
      <!-- ExternalNo: same as No (SAP material number) -->
      <ns0:ExternalNo>{eit:stripLeadingZeros(xs:string(MATNR))}</ns0:ExternalNo>
      
      <!-- Batch management: XCHPF=X → BatchNos=1 -->
      <xsl:if test="XCHPF = 'X'">
        <ns0:BatchNos>1</ns0:BatchNos>
        <ns0:ExpirationDateMandatory>true</ns0:ExpirationDateMandatory>
      </xsl:if>
      
      <!-- ReservationMethod: SLED_BBD=B (best before) → 3 = Expiration Date -->
      <xsl:variable name="reservationMethod" select="
        if      (SLED_BBD = 'B') then '3'
        else if (SLED_BBD = 'P') then '2'
        else                          '0'
                      "/>
      <ns0:ReservationMethod>{$reservationMethod}</ns0:ReservationMethod>
      
      <!-- Country of origin from plant data -->
      <xsl:variable name="herkl" select="(E1MARCM/HERKL[normalize-space(.) != ''])[1]"/>
      <xsl:if test="$herkl">
        <ns0:CountryofOriginCode>{$herkl}</ns0:CountryofOriginCode>
      </xsl:if>
      
      <!-- DefaultCarrierQuantity from WMS classification Z_WMS_PALHOEVH -->
      <xsl:variable name="palQty" select="eit:getCharact(., 'Z_WMS_PALHOEVH')"/>
      <xsl:if test="$palQty != ''">
        <ns0:DefaultCarrierQuantity>{$palQty}</ns0:DefaultCarrierQuantity>
      </xsl:if>
      
      <!-- Reorder point / quantity from plant MRP data -->
      <xsl:variable name="marcm" select="E1MARCM[1]"/>
      <xsl:if test="$marcm/MINBE != ''">
        <ns0:ReorderPoint>{$marcm/MINBE}</ns0:ReorderPoint>
      </xsl:if>
      <xsl:if test="$marcm/BSTMI != '' and number($marcm/BSTMI) != 0">
        <ns0:ReorderQuantity>{$marcm/BSTMI}</ns0:ReorderQuantity>
      </xsl:if>
      
      <!-- ==================== UNITS OF MEASURE ==================== -->
      <xsl:if test="E1MARMM">
        <ns0:UnitOfMeasures>
          <xsl:apply-templates select="E1MARMM">
            <xsl:with-param name="maram" select="."/>
          </xsl:apply-templates>
        </ns0:UnitOfMeasures>
      </xsl:if>
      
      <!-- ==================== TRANSLATIONS ==================== -->
      <xsl:if test="E1MAKTM">
        <ns0:Translations>
          <xsl:apply-templates select="E1MAKTM"/>
        </ns0:Translations>
      </xsl:if>
      
      <!-- ==================== TAX DATA PER COUNTRY ==================== -->
      <xsl:if test="E1MLANM">
        <ns0:CustomerItemTaxDatas>
          <xsl:apply-templates select="E1MLANM">
            <xsl:with-param name="maram" select="."/>
          </xsl:apply-templates>
        </ns0:CustomerItemTaxDatas>
      </xsl:if>
      
      <!-- ==================== ATTRIBUTES (Z1AUSPM) ==================== -->
      <xsl:if test="Z1AUSPM">
        <ns0:Attributes>
          <xsl:apply-templates select="Z1AUSPM"/>
        </ns0:Attributes>
      </xsl:if>
      
    </ns0:CustomerItem>
  </xsl:template>
  
  <!-- ============================================================
       E1MARMM → UnitOfMeasure
       ============================================================ -->
  <xsl:template match="E1MARMM">
    <xsl:param name="maram" as="element()"/>
    
    <!-- Conversion factor: prefer UMREZ (numerator) when > 1, else UMREN (denominator) -->
    <xsl:variable name="qty" select="
      if (number(UMREZ) gt 1) then UMREZ
      else                         UMREN
                    "/>
    
    <ns0:UnitOfMeasure>
      <ns0:Code>{MEINH}</ns0:Code>
      <ns0:QtyperUnitofMeasure>{$qty}</ns0:QtyperUnitofMeasure>
      
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
      
      <!-- EAN code: E1MEANM not present in this IDoc, emit nil -->
      <ns0:EANCode xsi:nil="true"/>
      
      <!-- Carrier info on the pallet UoM (PF = pallet) -->
      <xsl:variable name="carrierMatnr"
        select="eit:getCharact($maram, 'Z_WMS_DRAGER_MATNR')"/>
      <xsl:variable name="palQty"
        select="eit:getCharact($maram, 'Z_WMS_PALHOEVH')"/>
      <xsl:variable name="layers"
        select="eit:getCharact($maram, 'Z_WMS_LAYERS')"/>
      
      <xsl:if test="$carrierMatnr != '' and (MEINH = 'PF' or MEINH = $maram/MEINS)">
        <ns0:UnitOfMeasureCarriers>
          <ns0:UnitOfMeasureCarrier>
            <ns0:CarrierTypeCode>{$carrierMatnr}</ns0:CarrierTypeCode>
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
       E1MAKTM → Translation
       ============================================================ -->
  <xsl:template match="E1MAKTM">
    <!-- Resolve matching long text for same language -->
    <xsl:variable name="spras" select="xs:string(SPRAS)"/>
    <xsl:variable name="longText"
      select="(../E1MTXHM[TDSPRAS = $spras]/E1MTXLM[TDFORMAT = '*']/TDLINE)[1]"/>
    
    <ns0:Translation>
      <ns0:LanguageCode>{eit:sapLangToIso($spras)}</ns0:LanguageCode>
      <!-- Short description (MAKTX) as Description -->
      <ns0:Description>{MAKTX}</ns0:Description>
      <!-- Long text as Description2 when available -->
      <xsl:if test="$longText != ''">
        <ns0:Description2>{$longText}</ns0:Description2>
      </xsl:if>
    </ns0:Translation>
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
