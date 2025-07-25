<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript" 
                xmlns:ns0="www.boltrics.nl/receiveshipmentardo:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                version="3.0">
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    <xsl:key name="Lines-by-LineNo" match="s0:EFACT_D01B_INSDES/s0:LINLoop1" use="s0:LIN/LIN01" />
    <xsl:key name="Group-by-Item_UOM_Batch" match="//s0:LINLoop1"
        use="concat(s0:PIA[s0:C212_2/C21202 = 'SA']/s0:C212_2/C21201, '-', s0:QTY/s0:C186/C18603, '-', s0:PIA[s0:C212_2/C21202 = 'BB']/s0:C212_2/C21201)" />
    <xsl:template match="s0:EFACT_D01B_INSDES">
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
                    <xsl:text>5411361111123</xsl:text>
                </ns0:FromTradingPartner>
                <ns0:ToTradingPartner>
                    <xsl:value-of select="UNB/UNB2.2"/>
                </ns0:ToTradingPartner>
                <ns0:Information>
                    <xsl:text>RCV-SHIPMENT</xsl:text>
                </ns0:Information>
            </ns0:Header>
            <ns0:Documents>
                <ns0:Document>
                    <ns0:DocumentDate>
                        <xsl:value-of select="replace(s0:DTM/s0:C507[C50701 = '137']/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                    </ns0:DocumentDate>
                    <ns0:PostingDate>
                        <!-- Requested delivery date -->
                        <xsl:value-of select="replace(s0:DTM/s0:C507[C50701 = '2']/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                    </ns0:PostingDate>
                    <ns0:DeliveryDate>
                        <xsl:value-of select="replace(s0:DTM/s0:C507[C50701 = '200']/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                    </ns0:DeliveryDate>
                    <ns0:DepartedDate>
                        <xsl:value-of select="replace(s0:DTM/s0:C507[C50701 = '200']/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                    </ns0:DepartedDate>
                    <ns0:ExternalDocumentNo>
                        <xsl:value-of select="s0:BGM[1]/s0:C106[1]/C10601[1]" />
                    </ns0:ExternalDocumentNo>
                    <ns0:ExternalReference>
                        <xsl:value-of select="s0:RFFLoop1/s0:RFF/s0:C506[C50601='ON']/C50602" />
                    </ns0:ExternalReference>
                    <ns0:BuildingCode>
                        <xsl:text>ZFL-FR</xsl:text>
                    </ns0:BuildingCode>
                    <xsl:if test="s0:FTX[FTX01 = 'DEL']/s0:C108/C10801 != ''">
                        <ns0:DocumentComments>
                            <ns0:DocumentComment>
                                <ns0:Comment>
                                    <xsl:value-of select="s0:FTX[FTX01 = 'DEL']/s0:C108/C10801" />
                                </ns0:Comment>
                            </ns0:DocumentComment>
                        </ns0:DocumentComments>
                    </xsl:if>
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
                    <ns0:DepartedDate>
                        <xsl:value-of select="replace(s0:DTM/s0:C507[C50701 = '76']/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                    </ns0:DepartedDate>
                    <ns0:ShipToAddress>
                        <ns0:ExternalNo>
                            <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/s0:C082/C08201"/>
                        </ns0:ExternalNo>
                        <ns0:Name>
                            <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/s0:C080/C08001"/>
                        </ns0:Name>
                        <ns0:Address>
                            <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/s0:C059/C05901"/>
                        </ns0:Address>
                        <ns0:City>
                            <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/NAD06"/>
                        </ns0:City>
                        <ns0:PostCode>
                            <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/NAD08"/>
                        </ns0:PostCode>
                        <ns0:CountryCode>
                            <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/NAD09"/>
                        </ns0:CountryCode>
                    </ns0:ShipToAddress>
                    
                    <ns0:Attributes>
                        <ns0:Attribute>
                            <ns0:Code>ARDO_BULK</ns0:Code>
                            <ns0:Value>
                                <xsl:choose>
                                    <xsl:when test="//s0:QTY[s0:C186/C18601='113']/s0:C186/C18603 = 'KGM'">
                                        <xsl:text>true</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>false</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ns0:Value>
                        </ns0:Attribute>
                    </ns0:Attributes>
                    
                    <xsl:if test="count(s0:LINLoop1) &gt; 0">
                        <ns0:DocumentLines>
                           <xsl:for-each select="//s0:LINLoop1[count(. | key('Lines-by-LineNo', s0:LIN/LIN01)[1]) = 1]">
                                <xsl:variable name="LineKey" select="s0:LIN/LIN01" />
                                <xsl:if test="s0:LIN/LIN01 != ''">
                                <ns0:DocumentLine>
                                    <ns0:ExternalNo>
                                        <xsl:value-of select="s0:PIA[s0:C212_2/C21202 = 'SA']/s0:C212_2/C21201"/>
                                    </ns0:ExternalNo>
                                    <ns0:GTIN>
                                        <xsl:value-of select="s0:LIN[s0:C212/C21202 = 'SRV']/s0:C212/C21201"/>
                                    </ns0:GTIN>
                                    <!-- <ns0:OrderQuantity>
                                        <xsl:value-of select="s0:QTY/s0:C186/C18602" />
                                    </ns0:OrderQuantity> -->

                                    <xsl:choose>
                                        <!-- BULK -->
                                            <xsl:when test="key('Lines-by-LineNo',$LineKey)/s0:QTY[s0:C186/C18601='113']/s0:C186/C18603 = 'KGM'"> 
                                                <!-- <xsl:choose>
                                                    <xsl:when test="key('Lines-by-LineNo',$LineKey)/s0:QTY[s0:C186/C18601='17E']/s0:C186/C18602 = ''">
                                                        
                                                    </xsl:when>
                                                </xsl:choose> -->
                                                <ns0:OrderQuantity>
                                                    <xsl:value-of select="key('Lines-by-LineNo',$LineKey)/s0:QTY[s0:C186/C18601='17E']/s0:C186/C18602" />
                                                </ns0:OrderQuantity>
                                                <ns0:OrderUnitofMeasureCode>
                                                    <xsl:choose>
                                                        <xsl:when test="key('Lines-by-LineNo',$LineKey)/s0:QTY[s0:C186/C18601='17E']/s0:C186/C18603='PAL'">
                                                            <xsl:text>CRT</xsl:text>
                                                        </xsl:when>
                                                    </xsl:choose>
                                                </ns0:OrderUnitofMeasureCode>
                                            </xsl:when>

                                            <!-- Per TU -->
                                            <xsl:otherwise>
                                                <ns0:OrderQuantity>
                                                    <xsl:value-of select="key('Lines-by-LineNo',$LineKey)/s0:QTY[s0:C186/C18601='113']/s0:C186/C18602" />
                                                </ns0:OrderQuantity>
                                                <ns0:OrderUnitofMeasureCode>
                                                    <xsl:choose>
                                                        <xsl:when test="key('Lines-by-LineNo',$LineKey)/s0:QTY[s0:C186/C18601='113']/s0:C186/C18603='TU'">
                                                            <xsl:text>CRT</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="key('Lines-by-LineNo',$LineKey)/s0:QTY[s0:C186/C18601='113']/s0:C186/C18603='CU'">
                                                            <xsl:text>BAG</xsl:text>
                                                        </xsl:when>
                                                    </xsl:choose>
                                                </ns0:OrderUnitofMeasureCode>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    
                                    <ns0:Description>
                                        <xsl:value-of select="substring(s0:IMD/s0:C273/C27304, 1, 35)"/>
                                    </ns0:Description>

                                    <xsl:if test="s0:DTM_5/s0:C507_5/C50702 != ''">
                                        <ns0:ExpirationDate>
                                            <!-- <xsl:value-of select="MyScript:ParseDate(s0:DTM_5/s0:C507_5/C50702,'yyyyMMdd','yyyy-MM-dd')"/> -->
                                            <xsl:value-of select="replace(s0:DTM_5/s0:C507_5/C50702,'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                                        </ns0:ExpirationDate>
                                    </xsl:if>
                                    <xsl:if test="s0:PIA[s0:C212_2/C21202 = 'NB']/s0:C212_2/C21201 != ''">
                                        <ns0:ExternalBatchNo>
                                            <xsl:value-of select="s0:PIA[s0:C212_2/C21202 = 'NB']/s0:C212_2/C21201" />
                                        </ns0:ExternalBatchNo>
                                    </xsl:if>
                                    <ns0:Attributes>
                                        <ns0:Attribute>
                                            <ns0:Code>LINENO</ns0:Code>
                                            <ns0:Value>
                                                <xsl:value-of select="s0:PIA[s0:C212_2/C21202 = 'LI']/s0:C212_2/C21201" />
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
