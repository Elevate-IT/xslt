<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl MyScript s0" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <VIO-ACK>
      <UNH>
        <ReleaseId>1.1.0</ReleaseId>
        <ReleaseDate>2020-09-03T00:00:00</ReleaseDate>
        <Sender>72019</Sender>
        <Receiver>
          <xsl:value-of select="//s0:Header/s0:ToTradingPartner" />
        </Receiver>
        <MessageId>
          <xsl:value-of select="format-number(//s0:Header/s0:MessageID, '0000000')" />
        </MessageId>
        <MessageType>
          <xsl:text>Confirm</xsl:text>
        </MessageType>
      </UNH>
      <xsl:for-each select="//s0:DocumentDetailLine[s0:Posted = 1]">
        <xsl:variable name="CarrierNo" select="s0:CarrierNo" />
        <StockData>
          <PalletSSCCcode>
            <xsl:value-of select="s0:CarrierNo" />
          </PalletSSCCcode>
          <Type>
            <xsl:choose>
              <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCode = '90-GEBLOKKEERD'">
                <xsl:text>No reason provided</xsl:text>
              </xsl:when>
              <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCode = '99-RETOUR'">
                <xsl:text>No reason provided</xsl:text>
              </xsl:when>
              <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCode = '91-COMPRESSIE'">
                <xsl:text>Compressie</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>Confirm</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </Type>
          <DestinationWarehouse>
            <xsl:choose>
              <xsl:when test="../../../../s0:ShipToAddress/s0:No = 'BL'">
                <xsl:text>C900</xsl:text>
              </xsl:when>
              <xsl:when test="../../../../s0:ShipToAddress/s0:No = 'CR'">
                <xsl:text>C800</xsl:text>
              </xsl:when>
              <xsl:when test="../../../../s0:ShipToAddress/s0:No = 'GE'">
                <xsl:text>C500</xsl:text>
              </xsl:when>
              <xsl:when test="../../../../s0:ShipToAddress/s0:No = 'KL'">
                <xsl:text>C150</xsl:text>
              </xsl:when>
              <xsl:when test="../../../../s0:ShipToAddress/s0:No = 'OL'">
                <xsl:text>C400</xsl:text>
              </xsl:when>
              <xsl:when test="../../../../s0:ShipToAddress/s0:No = 'RT'">
                <xsl:choose>
                  <xsl:when test="../../../../s0:BuildingCode = 'BL'">
                    <xsl:text>394</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>C394</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="../../../../s0:ShipToAddress/s0:No = 'V1'">
                <xsl:text>C305</xsl:text>
              </xsl:when>
              <xsl:when test="../../../../s0:ShipToAddress/s0:No = 'V2'">
                <xsl:text>C305</xsl:text>
              </xsl:when>
              <xsl:when test="../../../../s0:ShipToAddress/s0:No = 'IN'">
                <xsl:choose>
                  <xsl:when test="../../../../s0:OrderTypeCode = 'NS'">
                    <xsl:text>100</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>C100</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </DestinationWarehouse>
          <xsl:if test="../../../../s0:VehicleNo != ''">
            <TrailerCode>
              <xsl:value-of select="substring(translate(../../../../s0:VehicleNo, translate(../../../../s0:VehicleNo, '0123456789', ''), ''), 1, 4)" />
            </TrailerCode>
          </xsl:if>
        </StockData>
      </xsl:for-each>
    </VIO-ACK>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      public string Replace(string input, string toReplace, string replaceTo)
			{
				return input.Replace(toReplace,replaceTo);
			}
      
			public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string ParseDate(string input, string formatIn, string formatOut)

      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }
      
      public int Abs(int input)
			{
				return Math.Abs(input);
			}
		]]>
  </msxsl:script>
</xsl:stylesheet>