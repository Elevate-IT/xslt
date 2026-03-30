<xsl:stylesheet
    version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:eit="http://www.elevate-it.be"
    xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="#all"
    expand-text="yes">

  <xsl:output method="xml" indent="yes" encoding="utf-8"/>

  <!-- ============================================================
       NAMED FUNCTIONS
       ============================================================ -->

  <!-- Combine SAP CREDAT (YYYYMMDD) + CRETIM (HHMMSS) into xs:dateTime string -->
  <xsl:function name="eit:sapDateTime" as="xs:string">
    <xsl:param name="date" as="xs:string"/>
    <xsl:param name="time" as="xs:string"/>
    <xsl:value-of select="concat(
      substring($date,1,4), '-', substring($date,5,2), '-', substring($date,7,2),
      'T',
      substring($time,1,2), ':', substring($time,3,2), ':', substring($time,5,2)
    )"/>
  </xsl:function>

  <!-- Convert SAP date YYYYMMDD → xs:date (YYYY-MM-DD); returns '' for 00000000 -->
  <xsl:function name="eit:sapDate" as="xs:string">
    <xsl:param name="d" as="xs:string"/>
    <xsl:value-of select="
      if ($d = '00000000' or normalize-space($d) = '') then ''
      else concat(substring($d,1,4), '-', substring($d,5,2), '-', substring($d,7,2))
    "/>
  </xsl:function>

  <!-- Convert SAP date DD.MM.YYYY → xs:date (YYYY-MM-DD) -->
  <xsl:function name="eit:dotDate" as="xs:string">
    <xsl:param name="d" as="xs:string"/>
    <!-- format: DD.MM.YYYY -->
    <xsl:value-of select="
      if (normalize-space($d) = '') then ''
      else concat(
        substring($d,7,4), '-',
        substring($d,4,2), '-',
        substring($d,1,2)
      )
    "/>
  </xsl:function>

  <!-- Strip leading zeros from SAP MATNR / numeric fields -->
  <xsl:function name="eit:stripZeros" as="xs:string">
    <xsl:param name="val" as="xs:string"/>
    <xsl:value-of select="
      if (matches($val, '^0+$')) then '0'
      else replace($val, '^0+', '')
    "/>
  </xsl:function>

  <!-- ============================================================
       ROOT TEMPLATE
       ============================================================ -->
  <xsl:template match="/">
    <xsl:apply-templates select="/ZDELVRY05/IDOC"/>
  </xsl:template>

  <!-- ============================================================
       IDOC → Message
       ============================================================ -->
  <xsl:template match="IDOC">
    <ns0:Message>
      <ns0:Header>
        <xsl:call-template name="Header"/>
      </ns0:Header>
      <ns0:Documents>
        <xsl:apply-templates select="E1EDL20"/>
      </ns0:Documents>
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
       E1EDL20 → Document
       ============================================================ -->
  <xsl:template match="E1EDL20">

    <!-- Resolve addresses -->
    <xsl:variable name="addrLF"  select="(E1ADRM1[PARTNER_Q = 'LF'])[1]"/>
    <xsl:variable name="addrOSP" select="(E1ADRM1[PARTNER_Q = 'OSP'])[1]"/>

    <!-- Resolve key dates from E1EDT13 segments -->
    <xsl:variable name="docDate"
      select="(E1EDT13[QUALF = '499'][EVENT = 'IDDOCUMENT']/NTANF)[1]"/>
    <xsl:variable name="delivDate"
      select="(E1EDT13[QUALF = '015']/NTANF)[1]"/>

    <ns0:Document>

      <!-- Delivery note number -->
      <ns0:ExternalDocumentNo>{VBELN}</ns0:ExternalDocumentNo>

      <!-- Document date from IDDOCUMENT event -->
      <xsl:variable name="docDateFmt" select="eit:sapDate(xs:string($docDate))"/>
      <xsl:if test="$docDateFmt != ''">
        <ns0:DocumentDate>{$docDateFmt}</ns0:DocumentDate>
      </xsl:if>

      <!-- Delivery date from QUALF=015 -->
      <xsl:variable name="delivDateFmt" select="eit:sapDate(xs:string($delivDate))"/>
      <xsl:if test="$delivDateFmt != ''">
        <ns0:DeliveryDate>{$delivDateFmt}</ns0:DeliveryDate>
      </xsl:if>

      <!-- Supplier's own delivery note reference -->
      <xsl:if test="normalize-space(LIFEX) != ''">
        <ns0:ExternalReference>{LIFEX}</ns0:ExternalReference>
      </xsl:if>

      <!-- ==================== SENDER ADDRESS (supplier) ==================== -->
      <xsl:if test="$addrLF">
        <ns0:SenderAddress>
          <xsl:call-template name="Address">
            <xsl:with-param name="addr" select="$addrLF"/>
          </xsl:call-template>
        </ns0:SenderAddress>
      </xsl:if>

      <!-- ==================== SHIP-TO ADDRESS (warehouse) ==================== -->
      <!-- <xsl:if test="$addrOSP">
        <ns0:ShipToAddress>
          <xsl:call-template name="Address">
            <xsl:with-param name="addr" select="$addrOSP"/>
          </xsl:call-template>
        </ns0:ShipToAddress>
      </xsl:if> -->

      <!-- ==================== DOCUMENT LINES ==================== -->
      <!-- Ignore Packaging lines: E1EDL24[E1EDL26/PSTYV = 'ELP']"-->
      <xsl:variable name="delivLines"
        select="E1EDL24[E1EDL26/PSTYV != 'ELP']"/>
      <xsl:if test="$delivLines">
        <ns0:DocumentLines>
          <xsl:apply-templates select="$delivLines"/>
        </ns0:DocumentLines>
      </xsl:if>

    </ns0:Document>
  </xsl:template>

  <!-- ============================================================
       ADDRESS helper template (shared by Sender/ShipTo/Shipper)
       ============================================================ -->
  <xsl:template name="Address">
    <xsl:param name="addr" as="element()"/>
    <!-- <xsl:if test="normalize-space($addr/PARTNER_ID) != ''">
      <ns0:ExternalNo>{$addr/PARTNER_ID}</ns0:ExternalNo>
    </xsl:if> -->
    <xsl:if test="normalize-space($addr/NAME1) != ''">
      <ns0:Name>{substring($addr/NAME1, 1, 50)}</ns0:Name>
    </xsl:if>
    <xsl:if test="normalize-space($addr/STREET1) != ''">
      <ns0:Address>{$addr/STREET1}</ns0:Address>
    </xsl:if>
    <xsl:if test="normalize-space($addr/POSTL_COD1) != ''">
      <ns0:PostCode>{$addr/POSTL_COD1}</ns0:PostCode>
    </xsl:if>
    <xsl:if test="normalize-space($addr/CITY1) != ''">
      <ns0:City>{$addr/CITY1}</ns0:City>
    </xsl:if>
    <xsl:if test="normalize-space($addr/COUNTRY1) != ''">
      <ns0:CountryCode>{$addr/COUNTRY1}</ns0:CountryCode>
    </xsl:if>
    <xsl:if test="normalize-space($addr/LANGUAGE) != ''">
      <ns0:LanguageCode>{$addr/LANGUAGE}</ns0:LanguageCode>
    </xsl:if>
  </xsl:template>

  <!-- ============================================================
       E1EDL24 → DocumentLine
       ============================================================ -->
  <xsl:template match="E1EDL24">

    <!-- Production date from E1EDL15 LOBM_HSDAT (format DD.MM.YYYY) -->
    <xsl:variable name="prodDateRaw"
      select="(E1EDL15[ATNAM = 'LOBM_HSDAT']/ATWRT)[1]"/>
    <xsl:variable name="prodDate"
      select="if (normalize-space($prodDateRaw) != '')
              then eit:dotDate(xs:string($prodDateRaw))
              else ''"/>

    <!-- Expiration date from VFDAT (YYYYMMDD) -->
    <xsl:variable name="expDate" select="eit:sapDate(xs:string(VFDAT))"/>

    <!-- Country of origin from E1EDL35 -->
    <xsl:variable name="herkl" select="(E1EDL35/HERKL[normalize-space(.) != ''])[1]"/>

    <ns0:DocumentLine>
      <!-- Material number (leading zeros stripped) -->
      <ns0:ExternalNo>{eit:stripZeros(xs:string(MATNR))}</ns0:ExternalNo>

      <!-- Short description -->
      <xsl:if test="normalize-space(ARKTX) != ''">
        <ns0:Description>{substring(ARKTX, 1, 50)}</ns0:Description>
      </xsl:if>

      <!-- Quantity delivered -->
      <xsl:if test="number(LGMNG) != 0">
        <ns0:OrderQuantity>{LGMNG}</ns0:OrderQuantity>
      </xsl:if>
      
      <!-- Unit of measure -->
      <xsl:if test="normalize-space(MEINS) != ''">
        <ns0:OrderUnitofMeasureCode>{MEINS}</ns0:OrderUnitofMeasureCode>
      </xsl:if>

      <!-- GTIN / EAN -->
      <xsl:if test="normalize-space(EAN11) != ''">
        <ns0:GTIN>{EAN11}</ns0:GTIN>
      </xsl:if>

      <!-- Weights -->
      <xsl:if test="number(BRGEW) != 0">
        <ns0:GrossWeight>{BRGEW}</ns0:GrossWeight>
      </xsl:if>
      <xsl:if test="number(NTGEW) != 0">
        <ns0:NetWeight>{NTGEW}</ns0:NetWeight>
      </xsl:if>

      <!-- Batch / lot number -->
      <xsl:if test="CHARG != ''">
        <ns0:ExternalBatchNo>{CHARG}</ns0:ExternalBatchNo>
      </xsl:if>

      <!-- Expiration date -->
      <xsl:if test="$expDate != ''">
        <ns0:ExpirationDate>{$expDate}</ns0:ExpirationDate>
      </xsl:if>

      <!-- Production date (from E1EDL15 classification) -->
      <xsl:if test="$prodDate != ''">
        <ns0:ProductionDate>{$prodDate}</ns0:ProductionDate>
      </xsl:if>
      
      <!-- Carrier type from parent HU -->
      <xsl:variable name="vhilm"
        select="substring(replace(../E1EDL37[E1EDL44/POSNR = current()/POSNR][1]/VHILM, 'PAL_', ''), 1, 10)"/>
      <xsl:if test="normalize-space($vhilm) != ''">
        <ns0:CarrierTypeCode>{$vhilm}</ns0:CarrierTypeCode>
      </xsl:if>

      <!-- Country of origin -->
      <!-- <xsl:if test="$herkl">
        <ns0:CountryofOriginCode>{$herkl}</ns0:CountryofOriginCode>
      </xsl:if> -->

      <!-- ==================== ATTRIBUTES (E1EDL15 classification) ==================== -->
      <!-- Exclude LOBM_HSDAT and LOBM_VFDAT (already mapped to dedicated fields) -->
      <xsl:variable name="attrs"
        select="E1EDL15[ATNAM != 'LOBM_HSDAT' and ATNAM != 'LOBM_VFDAT']"/>
      <xsl:if test="$attrs">
        <ns0:Attributes>
          <ns0:Attribute>
            <ns0:Code>LINENO</ns0:Code>
            <ns0:Value>
              <xsl:value-of select="POSNR"/>
            </ns0:Value>
          </ns0:Attribute>

          <!-- <xsl:apply-templates select="$attrs"/> -->
        </ns0:Attributes>
      </xsl:if>

      <!-- ==================== DOCUMENT DETAIL LINES (E1EDL44 carrier links) ==================== -->
      <xsl:if test="count(../E1EDL37[E1EDL44/POSNR = current()/POSNR]) &gt; 0">
        <ns0:DocumentDetailLines>
          <xsl:apply-templates select="../E1EDL37[E1EDL44/POSNR = current()/POSNR]" />
        </ns0:DocumentDetailLines>
      </xsl:if>

    </ns0:DocumentLine>
  </xsl:template>

  <!-- ============================================================
       E1EDL15 → Attribute
       ============================================================ -->
  <xsl:template match="E1EDL15">
    <!-- Truncate Code to 10 chars (schema maxLength) -->
    <xsl:variable name="code" select="substring(xs:string(ATNAM), 1, 10)"/>
    <ns0:Attribute>
      <ns0:Code>{$code}</ns0:Code>
      <ns0:Value>{
        if (normalize-space(ATWTB) != '') then xs:string(ATWTB)
        else xs:string(ATWRT)
      }</ns0:Value>
    </ns0:Attribute>
  </xsl:template>

  <!-- ============================================================
       E1EDL44 → DocumentDetailLine (carrier / SSCC assignment)
       ============================================================ -->
  <xsl:template match="E1EDL37">
    <ns0:DocumentDetailLine>
      <!-- SSCC of the handling unit this line belongs to -->
      <xsl:if test="normalize-space(EXIDV) != ''">
        <ns0:NVESSCC18No>{substring(EXIDV, string-length(EXIDV) - 17)}</ns0:NVESSCC18No>
      </xsl:if>
      
      <xsl:if test="number(E1EDL44/VEMNG) != 0">
        <ns0:OrderQuantity>{E1EDL44/VEMNG}</ns0:OrderQuantity>
      </xsl:if>
    </ns0:DocumentDetailLine>
  </xsl:template>

</xsl:stylesheet>
