<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="msxsl var xs" version="3.0"
                xmlns:ns0="www.boltrics.nl/receivetrip:v1.00">
  
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" indent="yes" />

  <xsl:key name="Group_by_PickingInstructions" match="DELIVERY/DespatchData" use="PickingInstructions" />

  <xsl:template match="/">
    <xsl:apply-templates select="//DESPATCH" />
  </xsl:template>

  <xsl:template match="//DESPATCH">
    <xsl:variable name="FirstLoadCarRunSeq">
      <xsl:value-of select="(DELIVERY/DespatchData[LoadSeq = '1']/FirstLoadCarRunSeq)[1]"/>
    </xsl:variable>
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/MessageId" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="current-dateTime()" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="UNH/Sender" />
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:value-of select="UNH/Receiver" />
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Trips>
        <ns0:Trip>
          <ns0:Date>
            <xsl:value-of select="let $d := string((DELIVERY/DespatchData/CarrierRunDate)[1]) return if ($d = '') then '' else format-date(xs:date(replace($d, '^(\d{4})(\d{2})(\d{2})$', '$1-$2-$3')), '[Y0001]-[M01]-[D01]')"/>
          </ns0:Date>
          <ns0:BuildingCode>
            <xsl:choose>
              <xsl:when test="DELIVERY/DespatchData[CarrierRunSeqId = $FirstLoadCarRunSeq]/PickingInstructions = '100'">
                <xsl:text>TURNHOUT 1</xsl:text>
              </xsl:when>
              <xsl:when test="DELIVERY/DespatchData[CarrierRunSeqId = $FirstLoadCarRunSeq]/PickingInstructions = '900'">
                <xsl:text>BL</xsl:text>
              </xsl:when>
              <xsl:when test="DELIVERY/DespatchData[CarrierRunSeqId = $FirstLoadCarRunSeq]/PickingInstructions = '1993'">
                <xsl:text>VOORKAAI</xsl:text>
              </xsl:when>
            </xsl:choose>
          </ns0:BuildingCode>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="(DELIVERY/DespatchData/CarrierRunId)[1]" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalRouteNo>
            <xsl:value-of select="(DELIVERY/DespatchData/CarrierRunId)[1]" />
          </ns0:ExternalRouteNo>
          <ns0:Attribute01>
            <xsl:choose>
              <xsl:when test="count(DELIVERY/DespatchData[generate-id(.) = generate-id(key('Group_by_PickingInstructions', PickingInstructions)[1])]) > 1">
                <xsl:text>Ja</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>Nee</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </ns0:Attribute01>
          <ns0:TripLines>
            <xsl:for-each select="DELIVERY">
              <ns0:TripLine>
                <ns0:LoadingSequence>
                  <xsl:value-of select="(DespatchData/LoadSeq)[1]" />
                </ns0:LoadingSequence>
                <ns0:ExternalDocumentNo>
                  <xsl:value-of select="concat((DespatchData/CarrierRunId)[1], '-', (CallOffData/DeliveryAddressId)[1])" />
                </ns0:ExternalDocumentNo>
                <ns0:DocumentType>2</ns0:DocumentType>
              </ns0:TripLine>
            </xsl:for-each>
          </ns0:TripLines>
        </ns0:Trip>
      </ns0:Trips>
    </ns0:Message>
  </xsl:template>
</xsl:stylesheet>