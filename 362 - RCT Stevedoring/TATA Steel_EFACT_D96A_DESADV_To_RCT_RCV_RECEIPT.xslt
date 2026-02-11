<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:eit="http://www.elevate-it.be"
                exclude-result-prefixes="#all" version="3.0">
  
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" indent="true"/>
  
  <xsl:function name="eit:createDate">
    <xsl:param name="inputDate"/>
    <xsl:value-of select="xs:date(concat(substring($inputDate, 1, 4), '-', substring($inputDate, 5, 2), '-', substring($inputDate, 7, 2)))" />
  </xsl:function>
  
  <xsl:function name="eit:createTime">
    <xsl:param name="inputTime"/>
    <xsl:value-of select="xs:time(concat(substring($inputTime, 1, 2), ':', substring($inputTime, 3, 2), ':00'))" />
  </xsl:function>
  
  <xsl:key name="Group-By-Item_UoM_Batch_CorusNo" match="//s0:PACLoop1"
    use="concat(../s0:LINLoop1/s0:LIN/s0:C212/C21201, '-',
        s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17401, '-',
        s0:PCILoop1/s0:GIR[GIR01 = '3']/s0:C206_2[C20602 = 'BX']/C20601, '-',
        concat(../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50602, ../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50603))" />
  
  <xsl:template match="s0:EFACT_D96A_DESADV">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/UNH1" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="dateTime(eit:createDate(s0:DTM/s0:C507[C50701=137]/C50702), eit:createTime(substring(s0:DTM/s0:C507[C50701=137]/C50702, 9, 4)))" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="normalize-space(UNB/UNB2.1)" />
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:value-of select="UNB/UNB2.2" />
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="eit:createDate(s0:DTM/s0:C507[C50701=137]/C50702)" />
          </ns0:DocumentDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="s0:RFFLoop1[s0:RFF/s0:C506/C50601 = 'AAS']/s0:RFF/s0:C506/C50602" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <xsl:value-of select="s0:BGM[s0:C002/C00201 = 351]/BGM02" />
          </ns0:ExternalReference>
          
          <ns0:SenderAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01 = 'CZ']/s0:NAD/s0:C082/C08201" />
            </ns0:ExternalNo>
            <ns0:Name>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01 = 'CZ']/s0:LOC/s0:C517/C51701" />
            </ns0:Name>
          </ns0:SenderAddress>
          
          <ns0:Attributes>
            <ns0:Attribute>
              <ns0:Code>EDI_TDT1</ns0:Code>
              <ns0:Value>
                <xsl:value-of select="s0:TDTLoop1/s0:TDT/s0:C220/C22001" />
              </ns0:Value>
            </ns0:Attribute>
            <ns0:Attribute>
              <ns0:Code>EDI_TDT2</ns0:Code>
              <ns0:Value>
                <xsl:value-of select="s0:TDTLoop1/s0:TDT/s0:C222/C22204" />
              </ns0:Value>
            </ns0:Attribute>
          </ns0:Attributes>
          
          <xsl:if test="count(//s0:PACLoop1) &gt; 0">
            <ns0:DocumentLines>
              <xsl:for-each select="//s0:PACLoop1[count(. | key('Group-By-Item_UoM_Batch_CorusNo', concat(../s0:LINLoop1/s0:LIN/s0:C212/C21201, '-',
                        s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17401, '-',
                        s0:PCILoop1/s0:GIR[GIR01 = '3']/s0:C206_2[C20602 = 'BX']/C20601, '-',
                        concat(../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50602, ../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50603)))[1]) = 1]">
                <xsl:variable name="LineKey" select="concat(../s0:LINLoop1/s0:LIN/s0:C212/C21201, '-',
                    s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17401, '-',
                    s0:PCILoop1/s0:GIR[GIR01 = '3']/s0:C206_2[C20602 = 'BX']/C20601, '-',
                    concat(../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50602, ../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50603))" />
                <xsl:if test="$LineKey != '--'">
                  <ns0:DocumentLine>
                    <ns0:No>
                      <xsl:choose>
                        <xsl:when test="../../s0:NADLoop1[s0:NAD/NAD01 = 'CZ']/s0:LOC/s0:C517/C51701 = 'IJMUIDEN' and ../s0:LINLoop1/s0:LIN/s0:C212/C21201 = '3010490'">
                          <xsl:text>RCTTATA-0004</xsl:text>
                        </xsl:when>
                        <xsl:when test="s0:PAC[PAC01 = '1']/s0:C202/C20201 = 'CL'">
                          <xsl:text>RCTTATA-0001</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="../s0:LINLoop1/s0:LIN/s0:C212/C21201" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </ns0:No>
                    <ns0:Description>
                      <xsl:value-of select="../s0:LINLoop1/s0:IMD[IMD01 = 'A']/s0:C273/C27304" />
                    </ns0:Description>
                    <ns0:OrderUnitofMeasureCode>
                      <xsl:choose>
                        <xsl:when test="s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17401 = 'KGM'">
                          <xsl:text>MT</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17401" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </ns0:OrderUnitofMeasureCode>
                    <ns0:OrderQuantity>
                      <xsl:choose>
                        <xsl:when test="s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17401 = 'KGM'">
                          <xsl:value-of select="sum(key('Group-By-Item_UoM_Batch_CorusNo',$LineKey)/s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17402) div 1000" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="sum(key('Group-By-Item_UoM_Batch_CorusNo',$LineKey)/s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17402)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </ns0:OrderQuantity>
                    <ns0:ExternalBatchNo>
                      <xsl:value-of select="s0:PCILoop1/s0:GIR[GIR01 = '3']/s0:C206_2[C20602 = 'BX']/C20601"/>
                    </ns0:ExternalBatchNo>
                    <ns0:NetWeight>
                      <xsl:value-of select="sum(key('Group-By-Item_UoM_Batch_CorusNo',$LineKey)/s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'AAL']/s0:C174_3/C17402)" />
                    </ns0:NetWeight>
                    <ns0:GrossWeight>
                      <xsl:value-of select="sum(key('Group-By-Item_UoM_Batch_CorusNo',$LineKey)/s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17402)" />
                    </ns0:GrossWeight>
                    <ns0:Attributes>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>REF1</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="concat(../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50602, ../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50603)" />
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>REF2</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="concat(../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50602, ../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50603)" />
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>EXTART</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="../s0:LINLoop1/s0:LIN/s0:C212/C21201" />
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>DOUANE</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:text>FREE GOODS</xsl:text>
                        </ns0:Value>
                      </ns0:Attribute>
                    </ns0:Attributes>
                    
                    <ns0:DocumentDetailLines>
                      <xsl:for-each select="key('Group-By-Item_UoM_Batch_CorusNo',$LineKey)/s0:PCILoop1">
                        <ns0:DocumentDetailLine>
                          <ns0:CarrierNo>
                            <xsl:value-of select="s0:GIR[GIR01 = '3']/s0:C206[C20602 = 'ML']/C20601" />
                          </ns0:CarrierNo>
                          <ns0:Length>
                            <xsl:value-of select="../../s0:LINLoop1/s0:MEA_4[MEA01 = 'PD'][s0:C502_4/C50201 = 'LN']/s0:C174_4/C17402" />
                          </ns0:Length>
                          <ns0:Width>
                            <xsl:value-of select="../../s0:LINLoop1/s0:MEA_4[MEA01 = 'PD'][s0:C502_4/C50201 = 'WD']/s0:C174_4/C17402" />
                          </ns0:Width>
                          <ns0:Height>
                            <xsl:value-of select="../../s0:LINLoop1/s0:MEA_4[MEA01 = 'PD'][s0:C502_4/C50201 = 'TH']/s0:C174_4/C17402" />
                          </ns0:Height>
                          <ns0:OrderQuantity>
                            <xsl:choose>
                              <xsl:when test="../s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17401 = 'KGM'">
                                <xsl:value-of select="../s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17402 div 1000" />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="../s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17402" />
                              </xsl:otherwise>
                            </xsl:choose>
                          </ns0:OrderQuantity>
                          <ns0:NetWeight>
                            <xsl:value-of select="../s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'AAL']/s0:C174_3/C17402" />
                          </ns0:NetWeight>
                          <ns0:GrossWeight>
                            <xsl:value-of select="../s0:MEA_3[MEA01 = 'AAY'][s0:C502_3/C50201 = 'G']/s0:C174_3/C17402" />
                          </ns0:GrossWeight>
                          <ns0:Attributes>
                            <ns0:Attribute>
                              <ns0:Code>
                                <xsl:text>REF1</xsl:text>
                              </ns0:Code>
                              <ns0:Value>
                                <xsl:value-of select="concat(../../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50602, ../../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50603)" />
                              </ns0:Value>
                            </ns0:Attribute>
                            <ns0:Attribute>
                              <ns0:Code>
                                <xsl:text>REF2</xsl:text>
                              </ns0:Code>
                              <ns0:Value>
                                <xsl:value-of select="concat(../../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50602, ../../s0:LINLoop1/s0:RFFLoop3[s0:RFF_4/s0:C506_4/C50601 = 'VN']/s0:RFF_4/s0:C506_4/C50603)" />
                              </ns0:Value>
                            </ns0:Attribute>
                            <ns0:Attribute>
                              <ns0:Code>
                                <xsl:text>EXTART</xsl:text>
                              </ns0:Code>
                              <ns0:Value>
                                <xsl:value-of select="../../s0:LINLoop1/s0:LIN/s0:C212/C21201" />
                              </ns0:Value>
                            </ns0:Attribute>
                            <ns0:Attribute>
                              <ns0:Code>
                                <xsl:text>DOUANE</xsl:text>
                              </ns0:Code>
                              <ns0:Value>
                                <xsl:text>FREE GOODS</xsl:text>
                              </ns0:Value>
                            </ns0:Attribute>
                          </ns0:Attributes>
                        </ns0:DocumentDetailLine>
                      </xsl:for-each>
                    </ns0:DocumentDetailLines>
                  </ns0:DocumentLine>
                </xsl:if>
              </xsl:for-each>
            </ns0:DocumentLines>
          </xsl:if>
        </ns0:Document>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template>
</xsl:stylesheet>