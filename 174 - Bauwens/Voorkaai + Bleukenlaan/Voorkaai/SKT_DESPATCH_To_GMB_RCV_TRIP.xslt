<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receivetrip:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="//DESPATCH" />
  </xsl:template>
  <xsl:template match="//DESPATCH">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/MessageId" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:GetCurrentDate('s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:text>1993</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:value-of select="UNH/Receiver" />
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Trips>
        <ns0:Trip>
          <ns0:Date>
            <xsl:value-of select="MyScript:ParseDate(DELIVERY/DespatchData/CarrierRunDate, 'yyyyMMdd', 'yyyy-MM-dd')" />
          </ns0:Date>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="DELIVERY/DespatchData/CarrierRunId" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalRouteNo>
            <xsl:value-of select="DELIVERY/DespatchData/CarrierRunId" />
          </ns0:ExternalRouteNo>

          <ns0:TripLines>
            <xsl:for-each select="DELIVERY">
              <ns0:TripLine>
                <ns0:LoadingSequence>
                  <xsl:value-of select="DespatchData/LoadSeq" />
                </ns0:LoadingSequence>
                <ns0:ExternalDocumentNo>
                  <xsl:value-of select="concat(DespatchData/CarrierRunId, '-', CallOffData/DeliveryAddressId, '-', DespatchData/LoadSeq)" />
                </ns0:ExternalDocumentNo>
                <ns0:DocumentType>2</ns0:DocumentType>
              </ns0:TripLine>
            </xsl:for-each>
          </ns0:TripLines>
        </ns0:Trip>
      </ns0:Trips>
    </ns0:Message>
    <xsl:value-of select="MyScript:Sleep()" />
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

      public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string ParseDate(string input, string formatIn, string formatOut)
      {
        if(System.String.IsNullOrEmpty(input)) return input;
        
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }    
      
      public void Sleep()
      {
        Threading.Thread.Sleep(60000);
      }

		]]>
  </msxsl:script>
</xsl:stylesheet>