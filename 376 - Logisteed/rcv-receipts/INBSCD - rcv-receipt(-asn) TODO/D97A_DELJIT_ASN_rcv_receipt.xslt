<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript"
                xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="3.0">
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    <xsl:key name="Lines-by-LineNo" match="s0:EFACT_D97A_DELJIT/s0:CPSLoop1/s0:LINLoop1" use="s0:LIN/LIN01" />
    <xsl:template match="s0:EFACT_D97A_DELJIT">
        <ns0:Message>
            <ns0:Header>
                <ns0:MessageID>
                    <xsl:value-of select="UNH/UNH1"/>
                </ns0:MessageID>
                <ns0:CreationDateTime>
                    <xsl:value-of select="current-dateTime()"/>
                </ns0:CreationDateTime>
                <ns0:ProcesAction>
                    <xsl:text>INSERT</xsl:text>
                </ns0:ProcesAction>
                <ns0:FromTradingPartner>
                    <!-- <xsl:value-of select="UNB/UNB2.1" /> -->
                    <xsl:text>JCHEU</xsl:text>
                </ns0:FromTradingPartner>
                <ns0:ToTradingPartner>
                    <xsl:text>LOGISTEED</xsl:text>
                </ns0:ToTradingPartner>
            </ns0:Header>
            <ns0:Documents>
                <ns0:Document>
                    <ns0:ExternalDocumentNo>
                        <xsl:value-of select="s0:BGM/s0:C106/C10601" />
                    </ns0:ExternalDocumentNo>
                    
                    <ns0:DeliveryDate>
                        <xsl:value-of select="replace(s0:DTM[s0:C507/C50701 = 137]/s0:C507/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')" />
                    </ns0:DeliveryDate>
                    <ns0:PlannedStartDate>
                        <xsl:value-of select="replace(s0:DTM[s0:C507/C50701 = 2]/s0:C507/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')" />
                    </ns0:PlannedStartDate>
                    <ns0:PlannedStartTime>
                        <xsl:value-of select="format-time(current-time(), '[H01]:[m01]')" />
                    </ns0:PlannedStartTime>
                    <ns0:PostingDate>
                        <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')" />
                    </ns0:PostingDate>
                    
                    <ns0:SenderAddress>
                        <ns0:EANCode>
                            <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/s0:C082/C08201" />
                        </ns0:EANCode>
                        <ns0:Name>
                            <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/s0:C080/C08001" />
                        </ns0:Name>
                        <ns0:Address>
                            <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/s0:C059/C05901" />
                        </ns0:Address>
                        <ns0:City>
                            <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/NAD06" />
                        </ns0:City>
                        <ns0:PostCode>
                            <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/NAD08" />
                        </ns0:PostCode>
                        <ns0:CountryCode>
                            <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/NAD09" />
                        </ns0:CountryCode>
                    </ns0:SenderAddress>
                    
                    <ns0:IncotermCode>
                        <xsl:value-of select="s0:FTX[FTX01 = 'Z99']/s0:C108/C10801" />
                    </ns0:IncotermCode>
                    
                    <!-- plant code -->
                    <ns0:Attribute03>
                        <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C082/C08201" />
                    </ns0:Attribute03>
                    
                    <!-- <ns0:SenderAddress>
                         <ns0:EANCode>                            
                         <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SF']/s0:C058/C05801" />
                         </ns0:EANCode>
                         </ns0:SenderAddress> -->
                    
                    <ns0:Attributes>
                        <ns0:Attribute>
                            <ns0:Code>EDIMSGTYPE</ns0:Code>
                            <ns0:Value>ASNReceipt</ns0:Value>
                        </ns0:Attribute>
                    </ns0:Attributes>
                    
                    <!-- PAC in Expect Qty. Carriers ?  -->
                    
                    <xsl:if test="count(//s0:LINLoop1)&gt;0">
                        <ns0:DocumentLines>
                            <xsl:for-each select="//s0:LINLoop1[count(. | key('Lines-by-LineNo', s0:LIN/LIN01)[1]) = 1]">
                                <xsl:variable name="LineKey" select="s0:LIN/LIN01" />
                                <xsl:if test="s0:LIN/LIN01 != ''">
                                    <ns0:DocumentLine>
                                        <!-- <ns0:GTIN>
                                            <xsl:value-of select="s0:LIN/s0:C212/C21201"/>
                                        </ns0:GTIN>
                                        <ns0:ExternalNo>
                                            <xsl:value-of select="s0:PIA[PIA01='1'][s0:C212_2/C21202 = 'ZZZ']/s0:C212_2/C21201"/>
                                        </ns0:ExternalNo> -->
                                        <ns0:ExternalNo>
                                            <xsl:value-of select="s0:LIN/s0:C212/C21201"/>
                                        </ns0:ExternalNo>
                                        <ns0:OrderQuantity>
                                            <xsl:value-of select="s0:QTYLoop1/s0:QTY/s0:C186/C18602"/>
                                        </ns0:OrderQuantity>
                                        <ns0:OrderUnitofMeasureCode>
                                            <xsl:value-of select="s0:QTYLoop1/s0:QTY/s0:C186/C18603"/>
                                        </ns0:OrderUnitofMeasureCode>
                                        <!-- <ns0:NetWeight>
                                             <xsl:value-of select="sum(key('Lines-by-LineNo',$LineKey)/s0:QTY_3[s0:C186_3/C18601='12']/s0:C186_3/C18602)" />
                                             </ns0:NetWeight> -->
                                        
                                        <!-- <ns0:OrderQuantity>
                                             <xsl:value-of select="sum(key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18602)" />
                                             </ns0:OrderQuantity>
                                             <ns0:OrderUnitofMeasureCode>
                                             <xsl:choose>
                                             <xsl:when test="key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18603='TU'">
                                             <xsl:text>CRT</xsl:text>
                                             </xsl:when>
                                             <xsl:when test="key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18603='CU'">
                                             <xsl:text>BAG</xsl:text>
                                             </xsl:when>
                                             </xsl:choose>
                                             </ns0:OrderUnitofMeasureCode> -->
                                        
                                        
                                        <!-- <ns0:CarrierQuantity>   
                                             <xsl:value-of select="../PACLoop1/PAC/PAC01"/>
                                             </ns0:CarrierQuantity> -->
                                        
                                        <!-- <xsl:if test="s0:PCILoop2/s0:DTM_9/s0:C507_9[C50701='94']/C50702 != ''">
                                             <ns0:ProductionDate>
                                             <xsl:value-of select="replace(s0:PCILoop2/s0:DTM_9/s0:C507_9[C50701='94']/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                                             </ns0:ProductionDate>
                                             </xsl:if>
                                             <xsl:if test="s0:PCILoop2/s0:DTM_10/s0:C507_10[C50701='361']/C50702 != ''">
                                             <ns0:ExpirationDate>
                                             <xsl:value-of select="replace(s0:PCILoop2/s0:DTM_10/s0:C507_10[C50701='361']/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                                             </ns0:ExpirationDate>
                                             </xsl:if> -->
                                        
                                        <!-- <ns0:ExternalBatchNo>
                                             <xsl:value-of select="s0:PCILoop2/s0:GINLoop2/s0:GIN_3[GIN01='BX']/s0:C208_12/C20801"/>
                                             </ns0:ExternalBatchNo> -->
                                        
                                        <!-- <ns0:Attributes>
                                             <ns0:Attribute>
                                             <ns0:Code>LINENO</ns0:Code>
                                             <ns0:Value>
                                             <xsl:value-of select="s0:PIA[s0:C212_2/C21202 = 'LI']/s0:C212_2/C21201" />
                                             </ns0:Value>
                                             </ns0:Attribute>
                                             </ns0:Attributes> -->
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
