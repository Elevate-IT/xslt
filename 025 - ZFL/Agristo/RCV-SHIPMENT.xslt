<xsl:stylesheet
    version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:eit="http://www.elevate-it.be"
    xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="#all"
    expand-text="yes">

  <xsl:output method="xml" indent="yes" encoding="utf-8"/>

  <!-- ============================================================
       NAMED FUNCTIONS 
       ============================================================ -->

  <!-- Combine SAP CREDAT (YYYYMMDD) + CRETIM (HHMMSS) → xs:dateTime string -->
  <xsl:function name="eit:sapDateTime" as="xs:string">
    <xsl:param name="date" as="xs:string"/>
    <xsl:param name="time" as="xs:string"/>
    <xsl:value-of select="concat(
      substring($date,1,4), '-', substring($date,5,2), '-', substring($date,7,2),
      'T',
      substring($time,1,2), ':', substring($time,3,2), ':', substring($time,5,2)
    )"/>
  </xsl:function>

  <!-- Convert SAP date YYYYMMDD → xs:date (YYYY-MM-DD); empty for 00000000 -->
  <xsl:function name="eit:sapDate" as="xs:string">
    <xsl:param name="d" as="xs:string"/>
    <xsl:value-of select="
      if ($d = '00000000' or normalize-space($d) = '') then ''
      else concat(substring($d,1,4), '-', substring($d,5,2), '-', substring($d,7,2))
    "/>
  </xsl:function>

  <!-- Strip leading zeros from SAP MATNR / numeric string -->
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

    <!-- Resolve partner addresses by role -->
    <xsl:variable name="addrOSP" select="(E1ADRM1[PARTNER_Q = 'OSP'])[1]"/>  <!-- own warehouse     -->
    <xsl:variable name="addrOSO" select="(E1ADRM1[PARTNER_Q = 'OSO'])[1]"/>  <!-- own sales org     -->
    <xsl:variable name="addrWE"  select="(E1ADRM1[PARTNER_Q = 'WE'])[1]"/>   <!-- ship-to customer  -->
    <xsl:variable name="addrSP"  select="(E1ADRM1[PARTNER_Q = 'SP'])[1]"/>   <!-- shipper/pick-up   -->
    <xsl:variable name="addrAG"  select="(E1ADRM1[PARTNER_Q = 'AG'])[1]"/>   <!-- sold-to customer  -->

    <!-- Resolve key dates from E1EDT13 -->
    <xsl:variable name="dateOrder"   select="(E1EDT13[QUALF = '001']/NTANF)[1]"/>
    <xsl:variable name="dateGI"      select="(E1EDT13[QUALF = '006']/NTANF)[1]"/>
    <xsl:variable name="dateDoc"   select="(E1EDT13[QUALF = '015']/NTANF)[1]"/>

    <!-- Customer PO from E1EDL41 (QUALI=001) -->
    <xsl:variable name="custPO"   select="(E1EDL24/E1EDL41[QUALI = '001'])[1]"/>
    <!-- Sales order reference from E1EDL43 (QUALF=C) -->
    <xsl:variable name="salesRef" select="(E1EDL24/E1EDL43[QUALF = 'C'])[1]"/>

    <ns0:Document>

      <!-- Delivery note number -->
      <ns0:ExternalDocumentNo>{VBELN}</ns0:ExternalDocumentNo>
      
      <!-- Customer purchase order number as external reference -->
      <xsl:if test="normalize-space($custPO/BSTNR) != ''">
        <ns0:ExternalReference>{$custPO/BSTNR}</ns0:ExternalReference>
      </xsl:if>

      <!-- Order / document date -->
      <xsl:variable name="docDateFmt" select="eit:sapDate(xs:string($dateDoc))"/>
      <xsl:if test="$docDateFmt != ''">
        <ns0:DocumentDate>{$docDateFmt}</ns0:DocumentDate>
      </xsl:if>

      <!-- Delivery date -->
      <xsl:variable name="giDateFmt" select="eit:sapDate(xs:string($dateGI))"/>
      <xsl:if test="$giDateFmt != ''">
        <ns0:ArrivedDate>{$giDateFmt}</ns0:ArrivedDate>
        <ns0:DepartedDate>{$giDateFmt}</ns0:DepartedDate>
        <ns0:PostingDate>{$giDateFmt}</ns0:PostingDate>
      </xsl:if>
      
      <ns0:OrderTypeCode>VRIJ</ns0:OrderTypeCode>

      <!-- Goods issue date used as posting date -->
      <!-- <xsl:variable name="giFmt" select="eit:sapDate(xs:string($dateGI))"/>
      <xsl:if test="$giFmt != ''">
        <ns0:PostingDate>{$giFmt}</ns0:PostingDate>
      </xsl:if> -->

      <!-- ==================== SENDER ADDRESS (own warehouse, PARTNER_Q=OSP) ==================== -->
      <!-- <xsl:if test="$addrOSP">
        <ns0:SenderAddress>
          <xsl:call-template name="Address">
            <xsl:with-param name="addr" select="$addrOSP"/>
          </xsl:call-template>
        </ns0:SenderAddress>
      </xsl:if> -->

      <!-- ==================== SHIP-TO (PARTNER_Q=WE) ==================== -->
      <xsl:if test="$addrWE">
        <ns0:ShipToAddress>
          <xsl:call-template name="Address">
            <xsl:with-param name="addr" select="$addrWE"/>
          </xsl:call-template>
        </ns0:ShipToAddress>
      </xsl:if>

      <!-- ==================== SHIPPER / PICK-UP (PARTNER_Q=SP) ==================== -->
      <!-- <xsl:if test="$addrSP">
        <ns0:ShipperAddress>
          <xsl:call-template name="Address">
            <xsl:with-param name="addr" select="$addrSP"/>
          </xsl:call-template>
        </ns0:ShipperAddress>
      </xsl:if> -->

      <!-- ==================== DOCUMENT LINES ==================== -->
      <xsl:if test="E1EDL24">
        <ns0:DocumentLines>
          <xsl:apply-templates select="E1EDL24"/>
        </ns0:DocumentLines>
      </xsl:if>

    </ns0:Document>
  </xsl:template>

  <!-- ============================================================
       ADDRESS helper template (reused for all partner roles)
       ============================================================ -->
  <xsl:template name="Address">
    <xsl:param name="addr" as="element()"/>
    <!-- <xsl:if test="normalize-space($addr/PARTNER_ID) != ''">
      <ns0:ExternalNo>{eit:stripZeros(xs:string($addr/PARTNER_ID))}</ns0:ExternalNo>
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
    <xsl:if test="normalize-space($addr/TELEPHONE1) != ''">
      <ns0:PhoneNo>{$addr/TELEPHONE1}</ns0:PhoneNo>
    </xsl:if>
    <xsl:if test="normalize-space($addr/TELEFAX) != ''">
      <ns0:FaxNo>{$addr/TELEFAX}</ns0:FaxNo>
    </xsl:if>
  </xsl:template>

  <!-- ============================================================
       E1EDL24 → DocumentLine
       ============================================================ -->
  <xsl:template match="E1EDL24">
    <!-- Country of origin from E1EDL35 -->
    <xsl:variable name="herkl"
      select="(E1EDL35/HERKL[normalize-space(.) != ''])[1]"/>

    <ns0:DocumentLine>
      <!-- Material number (leading zeros stripped) -->
      <ns0:ExternalNo>{eit:stripZeros(xs:string(MATNR))}</ns0:ExternalNo>

      <!-- Item description -->
      <xsl:if test="normalize-space(ARKTX) != ''">
        <ns0:Description>{substring(ARKTX, 1, 50)}</ns0:Description>
      </xsl:if>

      <!-- Delivered quantity -->
      <xsl:if test="number(LGMNG) != 0">
        <ns0:OrderQuantity>{LGMNG}</ns0:OrderQuantity>
      </xsl:if>
      
      <!-- Unit of measure -->
      <xsl:if test="normalize-space(MEINS) != ''">
        <ns0:OrderUnitofMeasureCode>{MEINS}</ns0:OrderUnitofMeasureCode>
      </xsl:if>

      <!-- GTIN / EAN barcode -->
      <xsl:if test="normalize-space(EAN11) != ''">
        <ns0:GTIN>{EAN11}</ns0:GTIN>
      </xsl:if>

      <!-- Weights -->
      <!-- <xsl:if test="number(BRGEW) != 0">
        <ns0:GrossWeight>{BRGEW}</ns0:GrossWeight>
      </xsl:if>
      <xsl:if test="number(NTGEW) != 0">
        <ns0:NetWeight>{NTGEW}</ns0:NetWeight>
      </xsl:if> -->

      <!-- Country of origin -->
      <!-- <xsl:if test="$herkl">
        <ns0:CountryofOriginCode>{$herkl}</ns0:CountryofOriginCode>
      </xsl:if> -->

      <!-- ==================== ATTRIBUTES (E1EDL35 customs/export data) ==================== -->
      <xsl:if test="E1EDL35">
        <ns0:Attributes>
          <ns0:Attribute>
            <ns0:Code>LINENO</ns0:Code>
            <ns0:Value>
              <xsl:value-of select="POSNR"/>
            </ns0:Value>
          </ns0:Attribute>
          
          <ns0:Attribute>
            <ns0:Code>CUSTQUAL</ns0:Code>
            <ns0:Value>
              <xsl:value-of select="LGORT"/>
            </ns0:Value>
          </ns0:Attribute>
          
          <!-- <xsl:apply-templates select="E1EDL35"/> -->
        </ns0:Attributes>
      </xsl:if>

    </ns0:DocumentLine>
  </xsl:template>

  <!-- ============================================================
       E1TXTH9 → DocumentLineComments
       Each text line (E1TXTP9) becomes a separate DocumentLineComment
       ============================================================ -->
  <xsl:template match="E1TXTH9">
    <xsl:param name="soDate" as="xs:string"/>
    <xsl:variable name="textId" select="xs:string(TDID)"/>
    <xsl:for-each select="E1TXTP9">
      <xsl:if test="normalize-space(TDLINE) != ''">
        <ns0:DocumentLineComment>
          <!-- Use document date if available -->
          <xsl:if test="$soDate != ''">
            <ns0:Date>{$soDate}</ns0:Date>
          </xsl:if>
          <!-- Text ID (Y011 etc.) as code — truncated to 20 chars -->
          <ns0:Code>{substring($textId, 1, 20)}</ns0:Code>
          <!-- Actual text line — truncated to 80 chars per schema -->
          <ns0:Comment>{substring(normalize-space(TDLINE), 1, 80)}</ns0:Comment>
        </ns0:DocumentLineComment>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- ============================================================
       E1EDL35 → Attributes (customs / export classification)
       Emits one Attribute per relevant field that has a value
       ============================================================ -->
  <xsl:template match="E1EDL35">
    <!-- Customs tariff number -->
    <xsl:if test="normalize-space(STAWN) != ''">
      <ns0:Attribute>
        <ns0:Code>STAWN</ns0:Code>
        <ns0:Description>Customs tariff number</ns0:Description>
        <ns0:Value>{STAWN}</ns0:Value>
      </ns0:Attribute>
    </xsl:if>
    <!-- Export procedure (text from E1EDL36) -->
    <xsl:if test="normalize-space(EXPRF) != ''">
      <ns0:Attribute>
        <ns0:Code>EXPRF</ns0:Code>
        <ns0:Description>Export/import procedure</ns0:Description>
        <ns0:Value>{
          if (normalize-space(E1EDL36/EXPRF_BEZ) != '')
          then xs:string(E1EDL36/EXPRF_BEZ)
          else xs:string(EXPRF)
        }</ns0:Value>
      </ns0:Attribute>
    </xsl:if>
    <!-- Business transaction type (text from E1EDL36) -->
    <xsl:if test="normalize-space(EXART) != ''">
      <ns0:Attribute>
        <ns0:Code>EXART</ns0:Code>
        <ns0:Description>Business transaction type</ns0:Description>
        <ns0:Value>{
          if (normalize-space(E1EDL36/EXART_BEZ) != '')
          then xs:string(E1EDL36/EXART_BEZ)
          else xs:string(EXART)
        }</ns0:Value>
      </ns0:Attribute>
    </xsl:if>
    <!-- Customs text lines from E1EDL36 -->
    <xsl:if test="normalize-space(E1EDL36/STXT1) != ''">
      <ns0:Attribute>
        <ns0:Code>CUSTDESC</ns0:Code>
        <ns0:Description>Customs goods description</ns0:Description>
        <ns0:Value>{normalize-space(concat(E1EDL36/STXT1, ' ', E1EDL36/STXT2))}</ns0:Value>
      </ns0:Attribute>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
