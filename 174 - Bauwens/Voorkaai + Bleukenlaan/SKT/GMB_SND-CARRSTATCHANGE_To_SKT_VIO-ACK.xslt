<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:s0="www.boltrics.nl/carrierstatuschange:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:CarrierStatusChanges[s0:CarrierStatusChange/s0:UserID != '']" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:CarrierStatusChanges">
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
      <xsl:for-each select="s0:CarrierStatusChange">
        <StockData>
          <PalletSSCCcode>
            <xsl:value-of select="s0:No" />
          </PalletSSCCcode>
          <Type>
            <xsl:choose>
              <xsl:when test="s0:NewStatusCode != ''">
                <xsl:choose>
                  <xsl:when test="s0:NewStatusCode = '90-GEBLOKKEERD'">
                    <xsl:choose>
                      <xsl:when test="s0:Reason != ''">
                        <xsl:value-of select="s0:Reason" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>No reason provided</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="s0:NewStatusCode = '99-RETOUR'">
                    <xsl:choose>
                      <xsl:when test="s0:Reason != ''">
                        <xsl:value-of select="s0:Reason" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>No reason provided</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="s0:NewStatusCode = '91-COMPRESSIE'">
                    <xsl:text>Compressie</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Confirm</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="s0:StatusCode = '90-GEBLOKKEERD'">
                    <xsl:choose>
                      <xsl:when test="s0:Reason != ''">
                        <xsl:value-of select="s0:Reason" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>No reason provided</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="s0:StatusCode = '99-RETOUR'">
                    <xsl:choose>
                      <xsl:when test="s0:Reason != ''">
                        <xsl:value-of select="s0:Reason" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>No reason provided</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="s0:StatusCode = '91-COMPRESSIE'">
                    <xsl:text>Compressie</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Confirm</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </Type>
          <DestinationWarehouse>
            <xsl:choose>
              <xsl:when test="s0:BuildingCode = 'VOORKAAI'">
                <xsl:choose>
                  <xsl:when test="s0:ContentLines/s0:CarrierContent/s0:LocationNo = 'TRANSIT'">
                    <xsl:choose>
                      <xsl:when test="count(s0:DestinationAddressCode) = 0">
                        <xsl:text>1993</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="s0:DocInTransit = '1'">
                            <xsl:choose>
                              <xsl:when test="s0:DestinationAddressCode = 'BL'">
                                <xsl:text>C900</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'CR'">
                                <xsl:text>C800</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'GE'">
                                <xsl:text>C500</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'KL'">
                                <xsl:text>C150</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'OL'">
                                <xsl:text>C400</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'RT'">
                                <xsl:text>C394</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'RM'">
                                <xsl:text>C392</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'V1'">
                                <xsl:text>C305</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'V2'">
                                <xsl:text>C305</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'IN'">
                                <xsl:text>C100</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'BR'">
                                <xsl:text>C700</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'ST'">
                                <xsl:text>C100</xsl:text>
                              </xsl:when>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="s0:DestinationAddressCode = 'BL'">
                                <xsl:text>T900</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'CR'">
                                <xsl:text>T800</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'GE'">
                                <xsl:text>T500</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'KL'">
                                <xsl:text>T150</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'OL'">
                                <xsl:text>T400</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'RT'">
                                <xsl:text>T394</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'RM'">
                                <xsl:text>T392</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'V1'">
                                <xsl:text>T305</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'V2'">
                                <xsl:text>T305</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'IN'">
                                <xsl:text>T100</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'BR'">
                                <xsl:text>T700</xsl:text>
                              </xsl:when>
                              <xsl:when test="s0:DestinationAddressCode = 'ST'">
                                <xsl:text>T100</xsl:text>
                              </xsl:when>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="s0:ContentLines/s0:CarrierContent/s0:LocationNo = 'P394'">
                    <xsl:text>P394</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>1993</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="s0:BuildingCode = 'BL'">
                <xsl:text>900</xsl:text>
              </xsl:when>
              <xsl:when test="s0:BuildingCode = 'TURNHOUT 1'">
                <xsl:text>100</xsl:text>
              </xsl:when>
            </xsl:choose>
          </DestinationWarehouse>
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