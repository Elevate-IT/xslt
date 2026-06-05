<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="var s0 xs"
                version="3.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0"/>
  <!--  Maximum LINLoop1 segments per output EFACT_D96A_INVRPT file.
       Pass a different value externally to change the split size.   -->
  <xsl:param name="MaxLinCount" as="xs:integer" select="110"/>
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document"/>
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <!--  Collect all Content items that will become LIN segments  -->
    <xsl:variable name="allLINItems" select="s0:Carriers/s0:Carrier/s0:Contents/s0:Content[s0:Posted = '1']"/>
    <DocumentSplitEnvelope>
      <xsl:for-each-group select="$allLINItems" group-by="ceiling(position() div $MaxLinCount)">
        <xsl:variable name="batchItems" select="current-group()"/>
        <Message Iteration="{current-grouping-key()}">
          <ns0:EFACT_D96A_INVRPT>
            <UNH>
              <UNH1>
                <xsl:value-of select="//s0:Header/s0:MessageID"/>
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
                <xsl:value-of select="//s0:Header/s0:MessageID"/>
              </BGM02>
              <BGM03>9</BGM03>
            </ns0:BGM>
            <ns0:DTM>
              <ns0:C507>
                <C50701>182</C50701>
                <C50702>
                  <!--<xsl:value-of select="format-date(xs:dateTime(//s0:Header/s0:CreationDateTime), '[Y0001][M01][D01][H01][m01]')" />-->
                  <xsl:value-of select="format-date(xs:date(s0:PostingDate), '[Y0001][M01][D01]')"/>
                </C50702>
                <C50703>102</C50703>
              </ns0:C507>
            </ns0:DTM>
            <ns0:RFFLoop1>
              <ns0:RFF>
                <ns0:C506>
                  <C50601>AAS</C50601>
                  <C50602>
                    <xsl:value-of select="s0:ExternalDocumentNo"/>
                  </C50602>
                </ns0:C506>
              </ns0:RFF>
            </ns0:RFFLoop1>
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
                    <xsl:value-of select="s0:BuildingCode"/>
                  </C51701>
                </ns0:C517>
                <ns0:C519>
                  <C51901>
                    <xsl:value-of select="s0:LocationNo"/>
                  </C51901>
                </ns0:C519>
              </ns0:LOC>
            </ns0:NADLoop1>
            <!--  ── LIN loop: iterate over this batch's Content items ──  -->
            <xsl:for-each select="$batchItems">
              <xsl:variable name="LineNo" select="s0:DocumentLineNo"/>
              <xsl:variable name="CarrierNo" select="s0:CarrierNo"/>
              <ns0:LINLoop1>
                <ns0:LIN>
                  <ns0:C212>
                    <C21201>
                      <xsl:choose>
                        <xsl:when test="s0:Attribute03 != ''">
                          <xsl:value-of select="s0:Attribute03"/>
                        </xsl:when>
                        <xsl:when test="s0:Attributes/s0:Attribute[s0:Code = 'EXTART']/s0:Value != ''">
                          <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'EXTART']/s0:Value"/>
                        </xsl:when>
                        <xsl:when test="//s0:DocumentDetailLine[s0:DocumentLineNo = $LineNo][s0:CarrierNo = $CarrierNo]/s0:Attributes/s0:Attribute[s0:Code = 'EXTART']/s0:Value != ''">
                          <xsl:value-of select="//s0:DocumentDetailLine[s0:DocumentLineNo = $LineNo][s0:CarrierNo = $CarrierNo]/s0:Attributes/s0:Attribute[s0:Code = 'EXTART']/s0:Value"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="//s0:DocumentLine[s0:LineNo = $LineNo]/s0:Attributes/s0:Attribute[s0:Code = 'EXTART']/s0:Value"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </C21201>
                    <C21202>IN</C21202>
                  </ns0:C212>
                </ns0:LIN>
                <ns0:QTYLoop2>
                  <ns0:QTY_2>
                    <ns0:C186_2>
                      <C18601>156</C18601>
                      <C18602>
                        <xsl:text>1</xsl:text>
                      </C18602>
                      <C18603>PCE</C18603>
                    </ns0:C186_2>
                  </ns0:QTY_2>
                  <ns0:INV>
                    <INV01>2</INV01>
                    <INV02>1</INV02>
                    <INV03>1</INV03>
                  </ns0:INV>
                  <ns0:DTM_8>
                    <ns0:C507_8>
                      <C50701>179</C50701>
                      <C50702>
                        <xsl:value-of select="format-date(xs:date(//s0:PostingDate), '[Y0001][M01][D01]')"/>
                      </C50702>
                      <C50703>102</C50703>
                    </ns0:C507_8>
                  </ns0:DTM_8>
                  <ns0:NADLoop2>
                    <ns0:NAD_2>
                      <NAD01>CA</NAD01>
                      <ns0:C082_2>
                        <C08201>RCT-WILLEBROEK</C08201>
                      </ns0:C082_2>
                      <xsl:variable name="EDI_TDT1" select="//s0:Attributes/s0:Attribute[s0:Code = 'EDI_TDT1']/s0:Value"/>
                      <xsl:if test="$EDI_TDT1 != ''">
                        <ns0:C058_2>
                          <C05801>
                            <xsl:choose>
                              <xsl:when test="$EDI_TDT1 = '10'">
                                <xsl:text>1</xsl:text>
                              </xsl:when>
                              <xsl:when test="$EDI_TDT1 = '20'">
                                <xsl:text>2</xsl:text>
                              </xsl:when>
                              <xsl:when test="$EDI_TDT1 = '30'">
                                <xsl:text>3</xsl:text>
                              </xsl:when>
                              <xsl:when test="$EDI_TDT1 = '80'">
                                <xsl:text>8</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="$EDI_TDT1"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </C05801>
                          <C05802>
                            <xsl:value-of select="//s0:Attributes/s0:Attribute[s0:Code = 'EDI_TDT2']/s0:Value"/>
                          </C05802>
                        </ns0:C058_2>
                      </xsl:if>
                    </ns0:NAD_2>
                  </ns0:NADLoop2>
                  <ns0:RFFLoop4>
                    <ns0:RFF_4>
                      <ns0:C506_4>
                        <C50601>AAK</C50601>
                        <C50602>
                          <xsl:value-of select="//s0:ExternalReference"/>
                        </C50602>
                      </ns0:C506_4>
                    </ns0:RFF_4>
                    <ns0:DTM_10>
                      <ns0:C507_10>
                        <C50701>171</C50701>
                        <C50702>
                          <xsl:value-of select="format-date(xs:date(//s0:DocumentDate), '[Y0001][M01][D01]')"/>
                        </C50702>
                        <C50703>102</C50703>
                      </ns0:C507_10>
                    </ns0:DTM_10>
                  </ns0:RFFLoop4>
                  <ns0:RFFLoop4>
                    <ns0:RFF_4>
                      <ns0:C506_4>
                        <xsl:variable name="VISInfo">
                          <xsl:choose>
                            <xsl:when test="s0:Attribute02 != ''">
                              <xsl:value-of select="s0:Attribute02"/>
                            </xsl:when>
                            <xsl:when test="s0:Attributes/s0:Attribute[s0:Code = 'REF2']/s0:Value != ''">
                              <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'REF2']/s0:Value"/>
                            </xsl:when>
                            <xsl:when test="//s0:DocumentDetailLine[s0:DocumentLineNo = $LineNo][s0:CarrierNo = $CarrierNo]/s0:Attributes/s0:Attribute[s0:Code = 'REF2']/s0:Value != ''">
                              <xsl:value-of select="//s0:DocumentDetailLine[s0:DocumentLineNo = $LineNo][s0:CarrierNo = $CarrierNo]/s0:Attributes/s0:Attribute[s0:Code = 'REF2']/s0:Value"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="//s0:DocumentLine[s0:LineNo = $LineNo]/s0:Attributes/s0:Attribute[s0:Code = 'REF2']/s0:Value"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="VISOrder" select="substring($VISInfo, 1, string-length($VISInfo) - 1)"/>
                        <xsl:variable name="VISItem" select="substring($VISInfo, string-length($VISInfo))"/>
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
                  <ns0:CPSLoop2>
                    <ns0:CPS_2>
                      <CPS01>
                        <xsl:value-of select="position()"/>
                      </CPS01>
                    </ns0:CPS_2>
                    <ns0:PACLoop2>
                      <ns0:PAC_2>
                        <PAC01>
                          <xsl:text>1</xsl:text>
                        </PAC01>
                        <!--To describe the number and type of packages/physical units-->
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
                  </ns0:CPSLoop2>
                </ns0:QTYLoop2>
              </ns0:LINLoop1>
            </xsl:for-each>
          </ns0:EFACT_D96A_INVRPT>
        </Message>
      </xsl:for-each-group>
    </DocumentSplitEnvelope>
  </xsl:template>
</xsl:stylesheet>
