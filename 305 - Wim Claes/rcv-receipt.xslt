<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:functx="http://www.functx.com"
                exclude-result-prefixes = "#all" >
    <xsl:output method="xml" indent="yes" version="1.0" />
    <xsl:template match="/">
        <xsl:apply-templates select="//Dossiers/Dossier" />
    </xsl:template>
    
    <xsl:template match="//Dossiers/Dossier">
        <ns0:Message>
            <ns0:Header>
                <ns0:MessageID>
                    <xsl:value-of select="substring-after(CallOffId, 'TAS_WIMCLAES_')" />
                </ns0:MessageID>
                <ns0:CreationDateTime>
                    <xsl:value-of select="current-dateTime()" />
                </ns0:CreationDateTime>
                <ns0:ProcesAction>
                    <xsl:choose>
                        <xsl:when test="/Dossiers/Dossier/Action = 0">
                            <xsl:text>INSERT</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>DELETE</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </ns0:ProcesAction>
                <ns0:FromTradingPartner>
                    <xsl:text>TAS</xsl:text>
                </ns0:FromTradingPartner>
                <ns0:ToTradingPartner>
                    <xsl:text>Wim Claes</xsl:text>
                </ns0:ToTradingPartner>
            </ns0:Header>
            
            <xsl:for-each select="Missions/Mission">
                <ns0:Documents>
                    <ns0:Document>
                        <ns0:DocumentDate>
                            <xsl:value-of select="xs:date(replace(/Dossiers/Dossier/Date, '([0-9]{4})/([0-9]{2})/([0-9]{2})', '$1-$2-$3')) "/>
                        </ns0:DocumentDate>
                        <ns0:ExternalDocumentNo>
                            <xsl:value-of select="/Dossiers/Dossier/DeliveryNote" />
                        </ns0:ExternalDocumentNo>
                        <ns0:ExternalReference>
                            <xsl:value-of select="/Dossiers/Dossier/Reference" />
                        </ns0:ExternalReference>
                        <ns0:SenderAddress>
                            <ns0:No>
                                <xsl:value-of select="Load/Number"/>
                            </ns0:No>
                            <ns0:Name>
                                <xsl:value-of select="Load/Name"/>
                            </ns0:Name>
                            <ns0:Address>
                                <xsl:value-of select="concat(Load/Street, ' ', Load/HouseNbr)"/>
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="Load/City"/>
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="Load/Zipcode"/>
                            </ns0:PostCode>
                            <ns0:CountryRegionCode>
                                <xsl:value-of select="Load/Country"/>
                            </ns0:CountryRegionCode>
                        </ns0:SenderAddress>
                        <ns0:ShipToAddress>
                            <ns0:No>
                                <xsl:value-of select="Unload/Number"/>
                            </ns0:No>
                            <ns0:Name>
                                <xsl:value-of select="Unload/Name"/>
                            </ns0:Name>
                            <ns0:Address>
                                <xsl:value-of select="concat(Unload/Street, ' ', Unload/HouseNbr)"/>
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="Unload/City"/>
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="Unload/Zipcode"/>
                            </ns0:PostCode>
                            <ns0:CountryRegionCode>
                                <xsl:value-of select="Unload/Country"/>
                            </ns0:CountryRegionCode>
                        </ns0:ShipToAddress>
                        <ns0:OrderTypeCode>
                            <xsl:text>CROSSDOCK</xsl:text>
                        </ns0:OrderTypeCode>
                        <ns0:PlannedStartDate>
                            <xsl:value-of select="xs:date(replace(Load/Date, '([0-9]{4})/([0-9]{2})/([0-9]{2})', '$1-$2-$3')) "/>
                        </ns0:PlannedStartDate>
                        <ns0:PlannedEndDate>
                            <xsl:value-of select="xs:date(replace(Unload/Date, '([0-9]{4})/([0-9]{2})/([0-9]{2})', '$1-$2-$3')) "/>
                        </ns0:PlannedEndDate>
                        <ns0:Customer>
                            <ns0:No>
                                <xsl:value-of select="/Dossiers/Dossier/Customer"/>
                            </ns0:No>
                        </ns0:Customer>
                        
                        <ns0:DocumentLines>
                            
                            <ns0:DocumentLine>
                                <ns0:ExternalNo>
                                    <xsl:text>CROSSDOCK</xsl:text>
                                </ns0:ExternalNo>                                    
                                <ns0:OrderQuantity>
                                    <!-- Corrects sequence of doubles in wrong format to right format and creates sum  -->
                                    <xsl:value-of select="sum(//Colli/number(translate(., ',', '.')))"/>
                                </ns0:OrderQuantity>
                                <ns0:DocumentDetailLines>
                                    <xsl:for-each select="Products/Product/Productdetails/Productdetail">
                                        <ns0:DocumentDetailLine>
                                            <ns0:CarrierNo>
                                                <xsl:value-of select="Barcode" />
                                            </ns0:CarrierNo>
                                            <ns0:OrderQuantity>
                                                <xsl:text>1</xsl:text>
                                            </ns0:OrderQuantity>
                                        </ns0:DocumentDetailLine>
                                    </xsl:for-each>
                                </ns0:DocumentDetailLines>
                            </ns0:DocumentLine>
                        </ns0:DocumentLines>
                    </ns0:Document>
                </ns0:Documents>
            </xsl:for-each>  
        </ns0:Message>
    </xsl:template>
</xsl:stylesheet>
