<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ns0="www.boltrics.nl/receiverecordlink:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">
  
  <xsl:output method="xml" indent="yes"/>
  
  <!-- Disable default copying -->
  <xsl:mode on-no-match="shallow-skip"/>
  
  <xsl:template match="xml/analyzeResult/documents/fields">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:text>1</xsl:text>
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="current-dateTime()" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:text>Hargo Logistics</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>Hargo Logistics</xsl:text>
        </ns0:ToTradingPartner>
      </ns0:Header>
      
      <ns0:Documents>
        <ns0:Document>
          <ns0:OriginalDocTitle>
            <xsl:value-of select="//sourceinformation/filename"/>
          </ns0:OriginalDocTitle>
          <ns0:DocTitle>
            <xsl:value-of select="DocTitle/valueString"/>
          </ns0:DocTitle>
          <ns0:OrderNo>            
            <xsl:value-of select="replace(OrderNo/valueString, '[^0-9 ]', '')"/>
          </ns0:OrderNo>
          <ns0:ContainerNo>
            <xsl:value-of select="ContainerNo/valueString"/>
          </ns0:ContainerNo>
          <ns0:ExternalDocNo>
            <xsl:value-of select="ExternalDocNo/valueString"/>
          </ns0:ExternalDocNo> 
          <ns0:VrachtbriefNo>
            <xsl:value-of select="VrachtbriefNo/valueString"/>
          </ns0:VrachtbriefNo> 
          <ns0:NCTSDocNo>
            <xsl:value-of select="NCTSDocNo/valueString"/>
          </ns0:NCTSDocNo>
          <ns0:PODeliveryNo>
            <xsl:value-of select="PODeliveryNo/valueString"/>
          </ns0:PODeliveryNo>
          <ns0:FactuurNo>
            <xsl:value-of select="FactuurNo/valueString"/>
          </ns0:FactuurNo> 
          <ns0:Base64Doc>
            <xsl:value-of select="//sourceinformation/filecontent"/>
          </ns0:Base64Doc>
        </ns0:Document>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template>
</xsl:stylesheet>