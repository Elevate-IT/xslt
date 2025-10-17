<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                exclude-result-prefixes="msxsl var s0"
                version="3.0"  > 
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    <xsl:template match="/">
        <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
    </xsl:template>
    <xsl:template match="//s0:Message/s0:Documents/s0:Document">
        <ns0:EFACT_D97A_DESADV>
            <UNH>
                <UNH1>
                    <xsl:value-of select="//s0:Header/s0:MessageID" />
                </UNH1>
                <UNH2>
                    <UNH2.1>DESADV</UNH2.1>
                    <UNH2.2>D</UNH2.2>
                    <UNH2.3>97A</UNH2.3>
                    <UNH2.4>UN</UNH2.4>
                    <UNH2.5>EDDS05</UNH2.5>
                </UNH2>
                <UNH4>
                    <UNH4.2>1</UNH4.2>
                </UNH4>
            </UNH>
            
            <ns0:BGM>
                <ns0:C002>
                    <C00201>351</C00201>
                    <C00204>RETURNS</C00204>
                </ns0:C002>
                <ns0:C106>
                    <C10601> <xsl:value-of select="s0:ExternalDocumentNo"/></C10601>
                </ns0:C106>
                <BGM03>9</BGM03>
            </ns0:BGM>
            
            <ns0:DTM>
                <ns0:C507>
                    <C50701>137</C50701>
                    <C50702>
                        <xsl:value-of select="format-date(s0:DocumentDate,'[Y0001][M01][D01]')" />
                    </C50702>
                    <C50703>102</C50703>
                </ns0:C507>
            </ns0:DTM>
            
            <ns0:DTM>
                <ns0:C507>
                    <C50701>11</C50701>
                    <C50702>
                        <xsl:value-of select="format-date(s0:PostingDate, '[Y0001][M01][D01]')" />
                    </C50702>
                    <C50703>102</C50703>
                </ns0:C507>
            </ns0:DTM>
            
            <ns0:RFFLoop1>
                <ns0:RFF>
                    <ns0:C506>
                        <C50601>SRN</C50601>
                        <C50602>
                            <xsl:value-of select="s0:No"/>
                        </C50602>
                    </ns0:C506>
                </ns0:RFF>
            </ns0:RFFLoop1>
            
            <ns0:NADLoop1>
                <ns0:NAD>
                    <NAD01>CN</NAD01>
                    <ns0:C082>
                        <C08201>
                            <xsl:choose>
                                <xsl:when test="s0:SenderAddress/s0:EANCode != ''">
                                    <xsl:value-of select="substring(translate(normalize-space(s0:SenderAddress/s0:EANCode),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),1,35)" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>ONE TIME</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
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
                            <xsl:value-of select="substring(translate(normalize-space(s0:Attribute03),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),1,35)" />
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
                <xsl:for-each select="//s0:Carriers/s0:Carrier/s0:Contents/s0:Content">
                    <ns0:LINLoop1>
                        <ns0:LIN>
                            <LIN01>
                                <xsl:value-of select="position()"/>
                            </LIN01>
                            <ns0:C212>
                                <C21201>
                                    <xsl:value-of select="s0:ExternalNo" />
                                </C21201>
                                <C21202>MF</C21202>
                                <C21203>92</C21203>
                            </ns0:C212>
                        </ns0:LIN>
                        
                        <ns0:PIA>
                            <PIA01>1</PIA01>
                            <ns0:C212_2>
                                <C21201>
                                    <xsl:variable name="QualIndicator" select="s0:Attribute01" />
                                    
                                    <xsl:variable name="MappedCode">
                                        <xsl:choose>
                                            <xsl:when test="$QualIndicator = 'AVAILABLE'">1</xsl:when>
                                            <xsl:when test="$QualIndicator = 'OUT OF WARRANTY'">10</xsl:when>
                                            <xsl:when test="$QualIndicator = 'DAMAGED CARTONS'">11</xsl:when>
                                            <xsl:when test="$QualIndicator = 'DAMAGED'">15</xsl:when>
                                            <xsl:when test="$QualIndicator = 'RETURN'">20</xsl:when>
                                            <xsl:when test="$QualIndicator = 'AWAITING SCRAP'">30</xsl:when>
                                            <xsl:when test="$QualIndicator = 'INSURANCE STOCK'">35</xsl:when>
                                            <xsl:when test="$QualIndicator = 'EXHIBITION STOCK'">40</xsl:when>
                                            <xsl:when test="$QualIndicator = 'RE-WORK (HACE)'">50</xsl:when>
                                            <xsl:when test="$QualIndicator = 'SERVICE (HACE)'">60</xsl:when>
                                            <xsl:when test="$QualIndicator = 'JCI SOUTH AND EXPORT'">S&amp;E</xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$QualIndicator"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    
                                    <xsl:value-of select="concat(s0:Attribute03, $MappedCode)" />
                                    
                                </C21201>
                                <C21202>ZZZ</C21202>
                                <C21204>90</C21204>
                            </ns0:C212_2>
                        </ns0:PIA>
                       
                        <ns0:QTY_2>
                            <ns0:C186_2>
                                <C18601>12</C18601>
                                <C18602>
                                    <xsl:value-of select="sum(s0:Quantity)" />
                                </C18602>
                                <C18603>
                                    <xsl:text>PCE</xsl:text>
                                </C18603>
                            </ns0:C186_2>
                        </ns0:QTY_2>
                    </ns0:LINLoop1>
                </xsl:for-each>
            </ns0:CPSLoop1>
        </ns0:EFACT_D97A_DESADV>
    </xsl:template>
</xsl:stylesheet>
