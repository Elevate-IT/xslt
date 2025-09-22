<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript" 
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                version="3.0">
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    <xsl:key name="Lines-by-LineNo" match="s0:EFACT_D97A_DELJIT/s0:SEQLoop1/s0:LINLoop1" use="s0:LIN/LIN01" />
    <xsl:key name="Group-by-Item_UOM_Batch" match="//s0:LINLoop1"
        use="concat(s0:PIA[s0:C212_2/C21202 = 'SA']/s0:C212_2/C21201, '-', s0:QTY/s0:C186/C18603, '-', s0:PIA[s0:C212_2/C21202 = 'BB']/s0:C212_2/C21201)" />
    <xsl:template match="s0:EFACT_D97A_DELJIT">
        <ns0:Message>
            <ns0:Header>
                <ns0:MessageID>
                    <xsl:value-of select="UNH/UNH1" />
                </ns0:MessageID>
                <ns0:CreationDateTime>
                    <xsl:value-of select="current-dateTime()" />
                </ns0:CreationDateTime>
                <ns0:ProcesAction>
                    <xsl:text>INSERT</xsl:text>
                </ns0:ProcesAction>
                <ns0:FromTradingPartner>
                    <xsl:text>JCHEU</xsl:text>
                </ns0:FromTradingPartner>
                <ns0:ToTradingPartner>
                    <xsl:text>LOGISTEED</xsl:text>
                </ns0:ToTradingPartner>
                <ns0:Information>
                    <xsl:text>RCV-SHIPMENT</xsl:text>
                </ns0:Information>
            </ns0:Header>
            <ns0:Documents>
                <ns0:Document> 
                    <ns0:ExternalDocumentNo>
                        <xsl:value-of select="s0:BGM/s0:C106/C10601" />
                    </ns0:ExternalDocumentNo>

                    <!-- <ns0:AnnouncedDate>
                        <xsl:value-of select="replace(s0:DTM/s0:C507[C50701 = '137']/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                    </ns0:AnnouncedDate>
                    <ns0:PlannedStartDate>
                        <xsl:value-of select="replace(s0:DTM[s0:C507/C50701 = '2']/s0:C507/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')" />
                    </ns0:PlannedStartDate>
                    <ns0:PlannedStartTime>
                        <xsl:value-of select="format-time(current-time(), '[H01]:[m01]')" />
                    </ns0:PlannedStartTime>
                    <ns0:PostingDate>
                        <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                    </ns0:PostingDate> -->
                    
                    <ns0:OrderDate>
                        <xsl:value-of select="replace(s0:DTM/s0:C507[C50701 = '137']/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                    </ns0:OrderDate>
                    <ns0:DeliveryDate>
                        <xsl:value-of select="replace(s0:DTM/s0:C507[C50701 = '2']/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                    </ns0:DeliveryDate>
                    
                    <ns0:Attribute01>
                        <xsl:value-of select="replace(s0:FTX[FTX01 = 'SIN'][starts-with(s0:C108/C10801, 'Created by:')]/s0:C108/C10801, 'Created by:', '')" />
                    </ns0:Attribute01>
                    
                    <xsl:if test="count(s0:FTX[FTX01='SIN']) &gt; 0">
                        <ns0:DocumentComments>
                            <xsl:for-each select="s0:FTX[FTX01='SIN']">
                                <ns0:DocumentComment>
                                <ns0:Date>
                                    <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                                </ns0:Date>
                                <ns0:Code>
                                    <xsl:text>WHSINSTRUCTION</xsl:text>
                                </ns0:Code>
                                <ns0:Comment>
                                    <xsl:value-of select="s0:C108/C10801"/>
                                </ns0:Comment>
                                </ns0:DocumentComment>
                            </xsl:for-each>
                        </ns0:DocumentComments>
                    </xsl:if>
                    
                    <xsl:if test="s0:NADLoop1/s0:NAD[NAD01 = 'CA']/s0:C058/C05801 != ''">
                        <ns0:ShippingAgentCode>
                            <xsl:value-of select="substring(s0:NADLoop1/s0:NAD[NAD01 = 'CA']/s0:C058/C05801, 1, 20)" />
                        </ns0:ShippingAgentCode>
                        <ns0:ShippingAgent>
                            <ns0:ExternalNo>
                                <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'SF']/s0:C082/C08201" />
                            </ns0:ExternalNo>
                            <ns0:Name>
                                <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'SF']/s0:C080/C08001" />
                            </ns0:Name>
                            <ns0:Address>
                                <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='SF']/s0:NAD/s0:C059/C05901"/>
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='SF']/s0:NAD/NAD06"/>
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='SF']/s0:NAD/NAD08"/>
                            </ns0:PostCode>
                            <ns0:CountryCode>
                                <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='SF']/s0:NAD/NAD09"/>
                            </ns0:CountryCode>
                        </ns0:ShippingAgent>
                    </xsl:if>
                    
                    <xsl:if test="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/s0:C082/C08201 != ''">
                        <ns0:ShipToAddress>
                            <xsl:choose>
                                <xsl:when test="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C082/C08201 != 'ONE TIME'" >
                                    <ns0:EANCode>
                                        <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C082/C08201" />
                                    </ns0:EANCode>
                                </xsl:when> 
                                <xsl:otherwise>
                                    <ns0:OneoffAddress>
                                        <xsl:text>True</xsl:text>
                                    </ns0:OneoffAddress>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            <ns0:Name>
                                <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C058/C05801" />
                            </ns0:Name> 
                            
                            <ns0:Address>
                                <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C058/C05804" />
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD06" />
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD08" />
                            </ns0:PostCode>
                            <ns0:CountryCode>
                                <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD09" />
                            </ns0:CountryCode>
                        </ns0:ShipToAddress>
                        
                        <ns0:ConsigneeAddress>
                            <xsl:choose>
                                <xsl:when test="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C082/C08201 != 'ONE TIME'" >
                                    <ns0:EANCode>
                                        <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C082/C08201" />
                                    </ns0:EANCode>
                                </xsl:when> 
                                <xsl:otherwise>
                                    <ns0:OneoffAddress>
                                        <xsl:text>True</xsl:text>
                                    </ns0:OneoffAddress>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            <ns0:Name>
                                <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C058/C05801" />
                            </ns0:Name> 
                            
                            <ns0:Address>
                                <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C058/C05804" />
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD06" />
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD08" />
                            </ns0:PostCode>
                            <ns0:CountryCode>
                                <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD09" />
                            </ns0:CountryCode>
                        </ns0:ConsigneeAddress>
                    </xsl:if>
                    
                    <ns0:IncotermCode>
                        <xsl:value-of select="s0:FTX[FTX01 = 'Z99']/s0:C108/C10801" />
                    </ns0:IncotermCode>
                    
                    <!-- plant code -->
                    <ns0:Attribute03>
                        <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/s0:C082/C08201" />       
                    </ns0:Attribute03>
                    
                    <ns0:Attributes>
                        <ns0:Attribute>
                            <ns0:Code>EDIMSGTYPE</ns0:Code>
                            <ns0:Value>DELIVERY_DELJIT_DESORD</ns0:Value>
                        </ns0:Attribute>
                    </ns0:Attributes>
                    
                    <xsl:if test="count(s0:SEQLoop1/s0:LINLoop1) &gt; 0">
                        <ns0:DocumentLines>
                            <xsl:for-each select="//s0:LINLoop1[count(. | key('Lines-by-LineNo', s0:LIN/LIN01)[1]) = 1]">
                                <xsl:variable name="LineKey" select="s0:LIN/LIN01" />
                                <xsl:if test="s0:LIN/LIN01 != ''">
                                    <ns0:DocumentLine>
                                        <ns0:ExternalNo>
                                            <xsl:value-of select="s0:LIN[s0:C212/C21202 = 'MF']/s0:C212/C21201"/>
                                        </ns0:ExternalNo>
                                        
                                        <!-- Order line reference -->
                                        <ns0:Attribute04>
                                            <xsl:value-of select="substring(key('Lines-by-LineNo',$LineKey)/s0:RFFLoop2[s0:RFF_2/s0:C506_2/C50601 = 'VN']/s0:RFF_2/s0:C506_2/C50602, 1, 35)"/>
                                        </ns0:Attribute04>
                                        
                                        <!-- <ns0:Description>
                                            <xsl:value-of select="substring(key('Lines-by-LineNo',$LineKey)/s0:RFFLoop2[s0:RFF_2/s0:C506_2/C50601 = 'ON']/s0:RFF_2/s0:C506_2/C50602, 1, 35)"/>
                                        </ns0:Description> -->
                                        
                                        <ns0:OrderQuantity>
                                            <xsl:value-of select="key('Lines-by-LineNo',$LineKey)/s0:QTYLoop1/s0:QTY[s0:C186/C18601='131']/s0:C186/C18602" />
                                        </ns0:OrderQuantity>
                                        <ns0:OrderUnitofMeasureCode>
                                            <xsl:value-of select="key('Lines-by-LineNo',$LineKey)/s0:QTYLoop1/s0:QTY[s0:C186/C18601='131']/s0:C186/C18603" />
                                        </ns0:OrderUnitofMeasureCode>
                                        
                                        <xsl:if test="s0:PIA[s0:C212_2/C21202 = 'NB']/s0:C212_2/C21201 != ''">
                                            <ns0:ExternalBatchNo>
                                                <xsl:value-of select="s0:PIA[s0:C212_2/C21202 = 'NB']/s0:C212_2/C21201" />
                                            </ns0:ExternalBatchNo>
                                        </xsl:if>
                                        
                                        <ns0:Attributes>
                                            <ns0:Attribute>
                                                <ns0:Code>EDILINENO</ns0:Code>
                                                <ns0:Value>
                                                    <xsl:value-of select="$LineKey" />
                                                </ns0:Value>
                                            </ns0:Attribute>
                                        </ns0:Attributes>

                                        <xsl:if test="count(s0:PCILoop1) &gt; 0">
                                            <ns0:DocumentDetailLines>
                                                <xsl:for-each select="s0:PCILoop1">
                                                    <ns0:DocumentDetailLine>
                                                        <ns0:CarrierNo>
                                                            <xsl:value-of select="s0:GIN_2/s0:C208_6/C20801"/>
                                                        </ns0:CarrierNo>
                                                    </ns0:DocumentDetailLine>
                                                </xsl:for-each>
                                            </ns0:DocumentDetailLines>
                                        </xsl:if>
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
