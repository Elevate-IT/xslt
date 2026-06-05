<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/receiveinvoice:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes = "#all" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    <xsl:variable name="OrderType" select="upper-case(/INVOIC02/IDOC/E1EDK01/VSART_BEZ)"/>
    
    <xsl:template match="/">
        <ns0:Message>
            <ns0:Header>
                <ns0:MessageID>
                    <xsl:value-of select="/INVOIC02/IDOC/EDI_DC40/DOCNUM" />
                </ns0:MessageID>
                <ns0:CreationDateTime>
                    <xsl:value-of select="current-dateTime()" />
                </ns0:CreationDateTime>
                <ns0:ProcesAction>
                    <xsl:text>INSERT</xsl:text>
                </ns0:ProcesAction>
                <ns0:FromTradingPartner>
                    <xsl:text>Ashland</xsl:text>
                </ns0:FromTradingPartner>
                <ns0:ToTradingPartner>
                    <xsl:text>Hargo Logistics</xsl:text>
                </ns0:ToTradingPartner>
            </ns0:Header>
            
            <ns0:Documents>
                <xsl:for-each select="/INVOIC02/IDOC">
                    <ns0:Document>
                        <ns0:DocumentDate>
                            <xsl:value-of select="E1EDK02[QUALF = '009']/DATUM"/>
                        </ns0:DocumentDate>
                        
                        <ns0:ExternalDocumentNo>
                            <xsl:value-of select="E1EDK01/BELNR" />
                        </ns0:ExternalDocumentNo>
                        
                        <ns0:OrderTypeCode>
                            <xsl:choose>
                                <xsl:when test="($OrderType = 'SEA')">
                                    <xsl:text>CONTAINER</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$OrderType"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </ns0:OrderTypeCode>
                        
                        <ns0:SenderAddress>
                            <ns0:No>
                                <xsl:value-of select="substring(E1EDKA1[PARVW = 'RS']/LIFNR, 1, 20)"/>
                            </ns0:No>
                            <ns0:Name>
                                <xsl:value-of select="substring(E1EDKA1[PARVW = 'RS']/NAME1, 1, 100)"/>
                            </ns0:Name>
                            <ns0:Address>
                                <xsl:value-of select="substring(E1EDKA1[PARVW = 'RS']/STRAS, 1, 100)"/>
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="substring(E1EDKA1[PARVW = 'RS']/ORT01, 1, 30)"/>
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="substring(E1EDKA1[PARVW = 'RS']/PSTLZ, 1, 20)"/>
                            </ns0:PostCode>
                            <ns0:CountryRegionCode>
                                <xsl:value-of select="substring(E1EDKA1[PARVW = 'RS']/LAND1, 1, 10)"/>
                            </ns0:CountryRegionCode>
                        </ns0:SenderAddress>

                        <ns0:TotalInvoiceAmount>
                            <xsl:value-of select="E1EDS01[SUMID = '010']/SUMME" />
                        </ns0:TotalInvoiceAmount>
                        
                        <ns0:DocumentLines>
                            <xsl:for-each select="E1EDP01[MENGE &gt; 0]">
                                <ns0:DocumentLine>

                                    <ns0:FeatureRecognition>
                                        <xsl:value-of select="E1EDP02[QUALF = '002']/ZEILE" />
                                    </ns0:FeatureRecognition>
                                    
                                    <ns0:ExternalNo>
                                        <xsl:value-of select="number(E1EDP19[QUALF = '002']/IDTNR)" />
                                    </ns0:ExternalNo>   
                                    
                                    <ns0:Attribute06>
                                        <xsl:value-of select="E1EDP02[QUALF = '002']/BELNR" />
                                    </ns0:Attribute06>
                                    
                                    <ns0:Attribute01>
                                        <xsl:value-of select="E1EDP02[QUALF = '016']/BELNR" />
                                    </ns0:Attribute01>

                                    <ns0:Quantity>
                                        <xsl:value-of select="MENGE" />
                                    </ns0:Quantity>
                                    
                                    <ns0:UnitofMeasureCode>
                                        <xsl:value-of select="MENEE" />
                                    </ns0:UnitofMeasureCode>

                                    <ns0:ExternalDocumentNo>
                                        <xsl:value-of select="../E1EDK01/BELNR" />
                                    </ns0:ExternalDocumentNo>

                                    <ns0:InvoiceDate>
                                        <xsl:value-of select="../E1EDK02[QUALF = '009']/DATUM" />
                                    </ns0:InvoiceDate>
                                    
                                    <ns0:InvoiceValue>
                                        <xsl:value-of select="E1EDP26[QUALF = '003']/BETRG" />
                                    </ns0:InvoiceValue>

                                    <ns0:CustomsCurrencyCode>
                                        <xsl:value-of select="../E1EDK01/CURCY" />
                                    </ns0:CustomsCurrencyCode>
                                    
                                </ns0:DocumentLine>
                            </xsl:for-each>
                        </ns0:DocumentLines>  
                    </ns0:Document>
                </xsl:for-each>  
            </ns0:Documents>
        </ns0:Message>
    </xsl:template>
</xsl:stylesheet>