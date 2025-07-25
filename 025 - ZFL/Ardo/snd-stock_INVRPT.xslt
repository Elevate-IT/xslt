<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/stockstatus:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                exclude-result-prefixes="msxsl var s0"
                version="3.0">
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    <xsl:template match="/">
        <xsl:apply-templates select="//s0:Message/s0:Customers/s0:Customer"/>
    </xsl:template>
    <xsl:template match="//s0:Message/s0:Customers/s0:Customer">
        <!-- <ns0:EANCOM_D01B_INVRPT> -->
        <ns0:EFACT_D01B_INVRPT>
            <!-- <UNB></UNB> -->
            <UNH>
                <UNH1>
                    <xsl:value-of select="//s0:Header/s0:MessageID" />
                </UNH1>
                <UNH2>
                    <UNH2.1>INVRPT</UNH2.1>
                    <UNH2.2>D</UNH2.2>
                    <UNH2.3>01B</UNH2.3>
                    <UNH2.4>UN</UNH2.4>
                </UNH2>
            </UNH>
            <ns0:BGM>
                <ns0:C002>
                    <C00201>35</C00201>
                </ns0:C002>
                <ns0:C106>    
                    <C10601>               
                        <xsl:value-of select="//s0:Header/s0:MessageID" />
                    </C10601>               
                </ns0:C106>
                <BGM03>9</BGM03>
            </ns0:BGM>
            <ns0:DTM>
                <ns0:C507>
                    <C50701>137</C50701>
                    <C50702>
                        <xsl:value-of select="format-dateTime(//s0:Header/s0:CreationDateTime,'[Y0001][M01][D01]')" />
                    </C50702>
                    <C50703>102</C50703>
                </ns0:C507>
            </ns0:DTM>
            <ns0:DTM>
                <ns0:C507>
                    <C50701>7</C50701>
                    <C50702>
                        <xsl:value-of select="format-dateTime(current-dateTime(), '[Y][M,2][D,2][H,2][m,2]')"/>
                    </C50702>
                    <C50703>203</C50703>
                </ns0:C507>
            </ns0:DTM>
            <ns0:NADLoop1>
                <ns0:NAD>
                    <NAD01>WH</NAD01>
                    <ns0:C082>
                        <C08201>
                            <xsl:value-of select="//s0:FromTradingPartner" />
                        </C08201>
                        <C08203>9</C08203>
                    </ns0:C082>
                    <ns0:C080>
                        <C08001>ZFL</C08001>
                    </ns0:C080>
                </ns0:NAD>
            </ns0:NADLoop1>
            
            <xsl:for-each select="s0:Carriers/s0:Carrier/s0:ContentLines/s0:CarrierContent">
                <xsl:variable name="ItemNo" as="node()*" select="s0:CustomerItemNo"/>
                <!-- <xsl:choose>
                    <xsl:when test="(position()<=5)"> -->
                    
                        <ns0:LINLoop1>
                            <ns0:LIN>
                                <LIN01>
                                    <xsl:value-of select="position()"/>
                                </LIN01>
                                <ns0:C212>
                                    <C21201>
                                        <xsl:value-of select="../../../../s0:Items/s0:Item[s0:No = $ItemNo ]/s0:EANCode" />
                                    </C21201>
                                    <C21202>EN</C21202>
                                </ns0:C212>
                            </ns0:LIN>
                            <ns0:PIA>
                                <PIA01>5</PIA01>
                                <ns0:C212_2>
                                    <C21201>
                                        <xsl:value-of select="s0:ExternalCustomerItemNo" />
                                    </C21201>
                                    <C21202>SA</C21202>
                                </ns0:C212_2>
                            </ns0:PIA>
                            <ns0:INVLoop1>
                                <ns0:INV>
                                    <INV04>
                                        <xsl:text>1</xsl:text>
                                    </INV04> 
                                </ns0:INV>  
                                
                                <ns0:QTY>
                                    <ns0:C186>
                                        <C18601>145</C18601>
                                        <C18602>
                                            <xsl:value-of select="s0:Quantity" />
                                        </C18602>
                                        <C18603>
                                            <xsl:choose>
                                                <xsl:when test="s0:UnitofMeasureCode='CRT'">
                                                    <xsl:text>TU</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="s0:UnitofMeasureCode='CU'">
                                                    <xsl:text>BAG</xsl:text>
                                                </xsl:when>
                                            </xsl:choose>
                                        </C18603>
                                    </ns0:C186>
                                </ns0:QTY>
                                <ns0:GIN>
                                    <GIN01>BJ</GIN01>
                                    <ns0:C208>
                                        <C20801>
                                            <xsl:value-of select="../../s0:No" />
                                        </C20801>
                                    </ns0:C208>
                                </ns0:GIN>
                                <ns0:GIN>
                                    <GIN01>BX</GIN01>
                                    <ns0:C208>
                                        <C20801>
                                            <xsl:value-of select="s0:ExBatchNo" />
                                        </C20801>
                                    </ns0:C208>
                                </ns0:GIN>
                                <ns0:DTM_4>
                                    <ns0:C507_4>
                                        <C50701>361</C50701>
                                        <C50702>
                                            <xsl:value-of select="format-date(s0:ExpirationDate,'[Y0001][M01][D01]')" />
                                        </C50702>
                                        <C50703>102</C50703>
                                    </ns0:C507_4>
                                </ns0:DTM_4>
                            </ns0:INVLoop1>
                            
                            
                            <!-- </ns0:INVLoop1>
                                 <ns0:QTYLoop2>
                                 <ns0:QTY_2>
                                 <ns0:C186_2>
                                 <C18601>145</C18601>
                                 <C18602>
                                 <xsl:value-of select="s0:Quantity" />
                                 </C18602>
                                 <C18603>
                                 <xsl:value-of select="s0:UnitofMeasureCode" />
                                 </C18603>
                                 </ns0:C186_2>
                                 </ns0:QTY_2>
                                 <ns0:GIN_2>
                                 <GIN01>BJ</GIN01>
                                 <ns0:C208_6>
                                 <C20801>
                                 <xsl:value-of select="../../s0:No" />
                                 </C20801>
                                 </ns0:C208_6>
                                 </ns0:GIN_2>
                                 <ns0:GIN_2>
                                 <GIN01>BX</GIN01>
                                 <ns0:C208_6>
                                 <C20801>
                                 <xsl:value-of select="s0:ExBatchNo" />
                                 </C20801>
                                 </ns0:C208_6>
                                 </ns0:GIN_2>
                                 <ns0:DTM_8>
                                 <ns0:C507_8>
                                 <C50701>361</C50701>
                                 <C50702>
                                 <xsl:value-of select="format-date(s0:ExpirationDate,'[Y0001][M01][D01]')" />
                                 </C50702>
                                 <C50703>102</C50703>
                                 </ns0:C507_8>
                                 </ns0:DTM_8>
                                 </ns0:QTYLoop2> -->
                         </ns0:LINLoop1>
                    <!-- </xsl:when>
                </xsl:choose> -->
            </xsl:for-each>
        </ns0:EFACT_D01B_INVRPT>
        <!-- </ns0:EANCOM_D01B_INVRPT> -->
    </xsl:template>
</xsl:stylesheet>
