<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/stockstatus:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                version="3.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />

  <xsl:key name="Group-By-Item-CorusNo" match="//s0:CarrierContent"
           use="concat(s0:Attribute03, '-', s0:Attribute02)" />


  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Customers/s0:Customer" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Customers/s0:Customer">
    <ns0:EFACT_D96A_INVRPT>
      <UNH>
        <UNH1>
          <xsl:value-of select="//s0:Header/s0:MessageID" />
        </UNH1>
        <UNH2>
          <UNH2.1>INVRPT</UNH2.1>
          <UNH2.2>D</UNH2.2>
          <UNH2.3>96A</UNH2.3>
          <UNH2.4>UN</UNH2.4>
        </UNH2>
      </UNH>

      <ns0:BGM>
        <ns0:C002>
          <C00201>35</C00201>
        </ns0:C002>
        <BGM02>
          <xsl:value-of select="//s0:Header/s0:MessageID" />
        </BGM02>
        <BGM03>9</BGM03>
      </ns0:BGM>

      <ns0:DTM>
        <ns0:C507>
          <C50701>182</C50701>
          <C50702>
            <xsl:value-of select="format-date(current-date(), '[Y0001][M01][D01]')" />
          </C50702>
          <C50703>203</C50703>
        </ns0:C507>
      </ns0:DTM>

      <!--<ns0:RFFLoop1>
				<ns0:RFF>
					<ns0:C506>
						<C50601>AAS</C50601>
						<C50602></C50602>
					</ns0:C506>
				</ns0:RFF>
			</ns0:RFFLoop1>-->

      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>WH</NAD01>
          <ns0:C082>
            <C08201>RCT-WILLEBROEK</C08201>
            <C08203>91</C08203>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>

      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>CN</NAD01>
          <ns0:C082>
            <C08201>RCT-WILLEBROEK</C08201>
            <C08203>91</C08203>
          </ns0:C082>
        </ns0:NAD>

        <ns0:LOC>
          <LOC01>11</LOC01>
          <ns0:C517>
            <C51701>
              <xsl:text>RCT</xsl:text>
            </C51701>
          </ns0:C517>
          <ns0:C519>
            <C51901>
              <xsl:text>PB1</xsl:text>
            </C51901>
          </ns0:C519>
        </ns0:LOC>
      </ns0:NADLoop1>

      <xsl:for-each select="//s0:CarrierContent[count(. | key('Group-By-Item-CorusNo', concat(s0:Attribute03, '-', s0:Attribute02))[1]) = 1]">
        <xsl:variable name="LineKey" select="concat(s0:Attribute03, '-', s0:Attribute02)" />
        <xsl:if test="$LineKey != '-'">
          <ns0:LINLoop1>
            <ns0:LIN>
              <!--<LIN01>
									<xsl:value-of select="MyScript:GetLinCounter()"/>
								</LIN01>-->
              <ns0:C212>
                <C21201>
                  <xsl:choose>
                    <xsl:when test="s0:Attribute03 != ''">
                      <xsl:value-of select="s0:Attribute03" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="s0:CustomerItemNo" />
                    </xsl:otherwise>
                  </xsl:choose>
                </C21201>
                <C21202>IN</C21202>
              </ns0:C212>
            </ns0:LIN>

            <!--<ns0:PIA>
								<PIA01>5</PIA01>
								<ns0:C212_2>
									<C21201>
										<xsl:value-of select="s0:ExternalCustomerItemNo" />
									</C21201>
									<C21202>SA</C21202>
								</ns0:C212_2>
							</ns0:PIA>-->

            <ns0:QTYLoop2>
              <ns0:QTY_2>
                <ns0:C186_2>
                  <C18601>156</C18601>
                  <C18602>
                    <xsl:value-of select="count(key('Group-By-Item-CorusNo',$LineKey))" />
                  </C18602>
                  <C18603>PCE</C18603>
                </ns0:C186_2>
              </ns0:QTY_2>

              <ns0:INV>
                <INV02>1</INV02>
                <INV04>1</INV04>
              </ns0:INV>

              <ns0:DTM_8>
                <ns0:C507_8>
                  <C50701>179</C50701>
                  <C50702>
                    <xsl:value-of select="format-date(current-date(), '[Y0001][M01][D01]')" />
                  </C50702>
                  <C50703>203</C50703>
                </ns0:C507_8>
              </ns0:DTM_8>

              <xsl:variable name="VISinfo">
                <xsl:value-of select="s0:Attribute02" />
              </xsl:variable>
              <xsl:if test="$VISinfo != ''">
                <ns0:RFFLoop4>
                  <ns0:RFF_4>
                    <ns0:C506_4>
                      <xsl:variable name="VISOrder">
                        <xsl:value-of select="substring($VISinfo, 1, string-length($VISinfo) - 1)" />
                      </xsl:variable>
                      <xsl:variable name="VISItem">
                        <xsl:value-of select="substring($VISinfo, string-length($VISinfo))" />
                      </xsl:variable>
                      <C50601>VN</C50601>
                      <C50602>
                        <xsl:value-of select="$VISOrder"/>
                      </C50602>
                      <C50603>
                        <xsl:value-of select="$VISItem"/>
                      </C50603>
                    </ns0:C506_4>
                  </ns0:RFF_4>
                </ns0:RFFLoop4>
              </xsl:if>


              <ns0:CPSLoop2>
                <ns0:CPS_2>
                  <CPS01>
                    <xsl:value-of select="position()"/>
                  </CPS01>
                </ns0:CPS_2>

                <xsl:for-each select="key('Group-By-Item-CorusNo',$LineKey)">
                  <ns0:PACLoop2>
                    <ns0:PAC_2>
                      <PAC01>1</PAC01>
                    </ns0:PAC_2>

                    <ns0:MEA_2>
                      <MEA01>AAY</MEA01>
                      <ns0:C502_2>
                        <C50201>G</C50201>
                      </ns0:C502_2>
                      <ns0:C174_2>
                        <C17401>KGM</C17401>
                        <C17402>
                          <xsl:value-of select="s0:GrossWeight"/>
                        </C17402>
                      </ns0:C174_2>
                    </ns0:MEA_2>

                    <ns0:MEA_2>
                      <MEA01>AAY</MEA01>
                      <ns0:C502_2>
                        <C50201>AAL</C50201>
                      </ns0:C502_2>
                      <ns0:C174_2>
                        <C17401>KGM</C17401>
                        <C17402>
                          <xsl:value-of select="s0:NetWeight"/>
                        </C17402>
                      </ns0:C174_2>
                    </ns0:MEA_2>

                    <ns0:PCILoop1>
                      <ns0:PCI_2>
                        <PCI01>17</PCI01>
                        <ns0:C827_2>
                          <C82701>S</C82701>
                        </ns0:C827_2>
                      </ns0:PCI_2>

                      <ns0:GIN_3>
                        <GIN01>ML</GIN01>
                        <ns0:C208_11>
                          <C20801>
                            <xsl:value-of select="s0:CarrierNo"/>
                          </C20801>
                        </ns0:C208_11>
                      </ns0:GIN_3>
                    </ns0:PCILoop1>
                  </ns0:PACLoop2>
                </xsl:for-each>

              </ns0:CPSLoop2>
            </ns0:QTYLoop2>
          </ns0:LINLoop1>
        </xsl:if>
      </xsl:for-each>
    </ns0:EFACT_D96A_INVRPT>
  </xsl:template>
</xsl:stylesheet>
