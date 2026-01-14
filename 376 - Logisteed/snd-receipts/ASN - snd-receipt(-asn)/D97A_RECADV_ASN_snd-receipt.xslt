<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                exclude-result-prefixes="msxsl var s0"
                version="3.0"  > 
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    
    <xsl:key name="average" match="s0:DocumentLines/s0:DocumentLine/s0:CarrierTypeCode" use="text()"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
    </xsl:template>
    <xsl:template match="//s0:Message/s0:Documents/s0:Document">
        <ns0:EFACT_D97A_RECADV>
            <UNH>
                <UNH1>
                    <xsl:value-of select="//s0:Header/s0:MessageID" />
                </UNH1>
                <UNH2>
                    <UNH2.1>RECADV</UNH2.1>
                    <UNH2.2>D</UNH2.2>
                    <UNH2.3>97A</UNH2.3>
                    <UNH2.4>UN</UNH2.4>
                    <UNH2.5>EDRC02</UNH2.5>
                </UNH2>
                <UNH4>
                    <UNH4.1>1</UNH4.1>
                </UNH4>
            </UNH>

            <ns0:BGM>
                <ns0:C002>
                    <C00201>632</C00201>
                </ns0:C002>
                <ns0:C106>
                    <C10601>
                        <xsl:value-of select="s0:ExternalDocumentNo" />
                    </C10601>
                </ns0:C106>
                <BGM03>9</BGM03>
            </ns0:BGM>
            
            <ns0:DTM>
                <ns0:C507>
                    <C50701>50</C50701>
                    <C50702>
                        <xsl:value-of select="format-date(s0:PostingDate, '[Y0001][M01][D01]')" />
                    </C50702>
                    <C50703>102</C50703>
                </ns0:C507>
            </ns0:DTM>
            
            <ns0:RFFLoop1>
                <ns0:RFF>
                    <ns0:C506>
                        <C50601>VN</C50601>
                        <C50602>
                            <xsl:value-of select="s0:ExternalDocumentNo" />
                        </C50602>
                    </ns0:C506>
                </ns0:RFF>
            </ns0:RFFLoop1>
            
            <ns0:NADLoop1>
                <ns0:NAD>
                    <NAD01>CN</NAD01>
                    <ns0:C082>
                        <C08201>
                            <xsl:value-of select="s0:Attribute03" />
                        </C08201>
                        <C08203>91</C08203>
                    </ns0:C082>
                </ns0:NAD>
            </ns0:NADLoop1>
            
            <ns0:NADLoop1>
                <ns0:NAD>
                    <NAD01>CZ</NAD01>
                    <ns0:C082>
                        <C08201>
                            <xsl:text>0001</xsl:text>
                        </C08201>
                        <C08203>91</C08203>
                    </ns0:C082>
                 </ns0:NAD>
            </ns0:NADLoop1>
            
            <ns0:CPSLoop1>
                <ns0:CPS>
                    <CPS01>
                        <xsl:text>1</xsl:text>
                    </CPS01>
                </ns0:CPS>        
                <!--</ns0:CPSLoop1> -->
                
                <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type='1']/s0:DocumentDetailLines/s0:DocumentDetailLine[s0:Posted = '1']">
                    <ns0:LINLoop1>
                        <ns0:LIN>
                            <LIN01>
                                <xsl:value-of select="position()"/>
                            </LIN01>
                            <C212>
                                <C21201>
                                    <xsl:value-of select="s0:ExternalNo" />
                                    <!-- <xsl:value-of select="s0:EANCode" /> -->
                                </C21201>
                                <C21202>MF</C21202>
                                <C21204>90</C21204>
                            </C212>
                        </ns0:LIN>

                        <ns0:PIA>
                            <PIA01>1</PIA01>
                            <ns0:C212_2>
                                <C21201>
                                    <xsl:variable name="QualIndicator" >
                                        <xsl:choose>
                                            <xsl:when test="s0:Attribute01 = 'AVAILABLE'">0001</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'AWAITING SCRAP'">AS01</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'BLOCKED'"></xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'DAMAGED'">DA01</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'DAMAGED CARTONS'">0028</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'EXHIBITION STOCK'">0040</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'FAULTY LOAN'">SA02</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'GRADED STOCK'">0014</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'INSURANCE NO STOCK'">IN02</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'INSURANCE STOCK'">IN01</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'INVESTIGATE/RE-WORK'">TE01</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'JCI SOUTH AND EXPORT'">140S&amp;E</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'NON-ROHS'">15</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'OLD SPECS'">0002</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'OLD STOCK'">0014</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'OUT OF WARRANTY'">WA01</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'RESERVED STOCK'">XX01</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'RETURNS'">RE01</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'RE-WORK (HACE)'">TE02</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'ROHS: AVAILABLE'"></xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'SAMPLE STOCK'">SA01</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'SERVICE (HACE)'">TE03</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'SHORTAGE'">SK99</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'STOCK DISCREPANCY'">SK99</xsl:when>
                                            <xsl:when test="s0:Attribute01 = 'SURPLUS'">SK99</xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="s0:Attribute01"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:value-of select="concat(s0:Attribute03, $QualIndicator)" />
                                </C21201>
                                <C21202>ZZZ</C21202>
                                <C21204>91</C21204>
                            </ns0:C212_2>
                        </ns0:PIA>

                        <ns0:QTY>
                            <ns0:C186>
                                <C18601>48</C18601>
                                <C18602>
                                    <xsl:value-of select="sum(s0:Quantity)" />
                                </C18602>
                                <C18603>
                                    <xsl:text>PCE</xsl:text>
                                </C18603>
                            </ns0:C186>
                        </ns0:QTY>

                    </ns0:LINLoop1>      
                </xsl:for-each>
            </ns0:CPSLoop1>
        </ns0:EFACT_D97A_RECADV>
    </xsl:template>
</xsl:stylesheet>

