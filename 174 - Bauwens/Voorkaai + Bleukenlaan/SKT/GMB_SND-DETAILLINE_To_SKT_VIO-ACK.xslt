<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:s0="www.boltrics.nl/senddetailline:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:DocumentDetailLines/s0:DocumentDetailLine" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:DocumentDetailLines/s0:DocumentDetailLine">
    <VIO-ACK>
      <UNH>
        <ReleaseId>1.1.0</ReleaseId>
        <ReleaseDate>2020-09-03T00:00:00</ReleaseDate>
        <Sender>72019</Sender>
        <Receiver>
          <xsl:value-of select="//s0:Header/s0:ToTradingPartner" />
        </Receiver>
        <MessageId>
          <xsl:choose>
            <xsl:when test="//s0:Header/s0:UniqueMessageNumber != ''">
              <xsl:value-of select="format-number(//s0:Header/s0:UniqueMessageNumber, '0000000')" />
              <!--<xsl:value-of select="//s0:Header/s0:UniqueMessageNumber" />-->
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="format-number(//s0:Header/s0:MessageID, '0000000')" />
            </xsl:otherwise>
          </xsl:choose>
        </MessageId>
        <MessageDate>
          <xsl:value-of select="MyScript:ParseDate(//s0:Header/s0:CreationDateTime, 's', 'yyyyMMdd')" />
        </MessageDate>
        <MessageTime>
          <xsl:value-of select="MyScript:ParseDate(//s0:Header/s0:CreationDateTime, 's', 'HHmmss')" />
        </MessageTime>
        <MessageType>
          <xsl:text>Confirm</xsl:text>
        </MessageType>
        <MessageName>
          <xsl:text>VIO-ACK</xsl:text>
        </MessageName>
      </UNH>
      <xsl:variable name="CarrierNo" select="s0:CarrierNo" />
      <xsl:choose>
        <xsl:when test="count(s0:Posted) = 0">
          <StockData>
            <PalletSSCCcode>
              <xsl:value-of select="s0:CarrierNo" />
            </PalletSSCCcode>
            <Type>
              <xsl:choose>
                <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCodeOnTrigger != ''">
                  <xsl:choose>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCodeOnTrigger = '90-GEBLOKKEERD'">
                      <xsl:choose>
                        <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason != ''">
                          <xsl:value-of select="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>No reason provided</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCodeOnTrigger = '99-RETOUR'">
                      <xsl:choose>
                        <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason != ''">
                          <xsl:value-of select="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>No reason provided</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCodeOnTrigger = '91-COMPRESSIE'">
                      <xsl:text>Compressie</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>Confirm</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCode != ''">
                  <xsl:choose>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCode = '90-GEBLOKKEERD'">
                      <xsl:choose>
                        <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason != ''">
                          <xsl:value-of select="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>No reason provided</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCode = '99-RETOUR'">
                      <xsl:choose>
                        <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason != ''">
                          <xsl:value-of select="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>No reason provided</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCode = '91-COMPRESSIE'">
                      <xsl:text>Compressie</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>Confirm</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>Confirm</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </Type>
            <DestinationWarehouse>
              <xsl:choose>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'BL'">
                  <xsl:text>T900</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'CR'">
                  <xsl:text>T800</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'GE'">
                  <xsl:text>T500</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'KL'">
                  <xsl:text>T150</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'OL'">
                  <xsl:text>T400</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'RT'">
                  <xsl:text>T394</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'RM'">
                  <xsl:text>T392</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'V1'">
                  <xsl:text>T305</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'V2'">
                  <xsl:text>T305</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'BR'">
                  <xsl:text>T700</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'ST'">
                  <xsl:text>T100</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'IN'">
                  <xsl:choose>
                    <xsl:when test="../s0:Documents/s0:Document/s0:OrderTypeCode = 'NS'">
                      <xsl:text>100</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>T100</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
              </xsl:choose>
            </DestinationWarehouse>
            <xsl:if test="../s0:Documents/s0:Document/s0:VehicleNo != ''">
              <TrailerCode>
                <xsl:value-of select="substring(translate(../s0:Documents/s0:Document/s0:VehicleNo, translate(../s0:Documents/s0:Document/s0:VehicleNo, '0123456789', ''), ''), 1, 4)" />
              </TrailerCode>
            </xsl:if>
          </StockData>
        </xsl:when>

        <xsl:when test="s0:Posted = 1">
          <StockData>
            <PalletSSCCcode>
              <xsl:value-of select="s0:CarrierNo" />
            </PalletSSCCcode>
            <Type>
              <xsl:choose>
                <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCodeOnTrigger != ''">
                  <xsl:choose>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCodeOnTrigger = '90-GEBLOKKEERD'">
                      <xsl:choose>
                        <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason != ''">
                          <xsl:value-of select="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>No reason provided</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCodeOnTrigger = '99-RETOUR'">
                      <xsl:choose>
                        <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason != ''">
                          <xsl:value-of select="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>No reason provided</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCodeOnTrigger = '91-COMPRESSIE'">
                      <xsl:text>Compressie</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>Confirm</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCode != ''">
                  <xsl:choose>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCode = '90-GEBLOKKEERD'">
                      <xsl:choose>
                        <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason != ''">
                          <xsl:value-of select="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>No reason provided</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCode = '99-RETOUR'">
                      <xsl:choose>
                        <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason != ''">
                          <xsl:value-of select="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusReason" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>No reason provided</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="//s0:Carrier[s0:No = $CarrierNo]/s0:StatusCode = '91-COMPRESSIE'">
                      <xsl:text>Compressie</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>Confirm</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>Confirm</xsl:text>
                </xsl:otherwise>
              </xsl:choose>

            </Type>
            <DestinationWarehouse>
              <xsl:choose>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'BL'">
                  <xsl:text>900</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'CR'">
                  <xsl:text>T800</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'GE'">
                  <xsl:text>T500</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'KL'">
                  <xsl:text>150</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'OL'">
                  <xsl:text>400</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'RT'">
                  <xsl:text>T394</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'RM'">
                  <xsl:text>T392</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'V1'">
                  <xsl:text>T305</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'V2'">
                  <xsl:text>T305</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'IN'">
                  <xsl:text>100</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'BR'">
                  <xsl:text>T700</xsl:text>
                </xsl:when>
                <xsl:when test="../s0:Documents/s0:Document/s0:ShipToAddress/s0:No = 'ST'">
                  <xsl:text>100</xsl:text>
                </xsl:when>
              </xsl:choose>
            </DestinationWarehouse>
            <xsl:if test="../s0:Documents/s0:Document/s0:VehicleNo != ''">
              <TrailerCode>
                <xsl:value-of select="substring(translate(../s0:Documents/s0:Document/s0:VehicleNo, translate(../s0:Documents/s0:Document/s0:VehicleNo, '0123456789', ''), ''), 1, 4)" />
              </TrailerCode>
            </xsl:if>
          </StockData>
        </xsl:when>
      </xsl:choose>
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