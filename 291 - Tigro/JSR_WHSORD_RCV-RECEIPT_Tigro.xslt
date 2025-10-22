<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:eit="http://www.elevate-it.be"
                exclude-result-prefixes = "#all" >   
    
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:function name="eit:createDate">
        <xsl:param name="idocDate"/>
        <xsl:value-of select="xs:date(concat(substring($idocDate, 1, 4), '-', substring($idocDate, 5, 2), '-', substring($idocDate, 7, 2)))" />
    </xsl:function>
    
    <xsl:function name="eit:createTime">
        <xsl:param name="idocTime"/>
        <xsl:value-of select="xs:time(concat(substring($idocTime, 1, 2), ':', substring($idocTime, 3, 2), ':', substring($idocTime, 5, 2)))" />
    </xsl:function>
    
    <xsl:template match="/">
        <xsl:apply-templates select="ZDLVRY03/IDOC"/>
    </xsl:template>
    
    <xsl:template match="ZDLVRY03/IDOC">
        <ns0:Message>
            <ns0:Header>
                <ns0:MessageID>
                    <xsl:value-of select="EDI_DC40/DOCNUM" />
                </ns0:MessageID>
                <ns0:CreationDateTime>
                    <xsl:value-of select="dateTime(eit:createDate(EDI_DC40/CREDAT), eit:createTime(EDI_DC40/CRETIM))"/>
                </ns0:CreationDateTime>
                <ns0:ProcesAction>
                    <xsl:text>INSERT</xsl:text>
                </ns0:ProcesAction>
                <ns0:FromTradingPartner>
                    <xsl:text>JSR</xsl:text>
                </ns0:FromTradingPartner>
                <ns0:ToTradingPartner>
                    <xsl:text>Tigro</xsl:text>
                </ns0:ToTradingPartner>
            </ns0:Header>
            
            <ns0:Documents>
                <xsl:for-each select="E1EDL20">
                    <ns0:Document>
                        <ns0:DocumentDate>
                            <xsl:value-of select="eit:createDate(E1EDT13[QUALF = '015']/NTANF)"/>
                        </ns0:DocumentDate>
                        
                        <ns0:ExternalDocumentNo>
                            <xsl:value-of select="VBELN" />
                        </ns0:ExternalDocumentNo>
                        
                        <ns0:ExternalReference>
                            <xsl:value-of select="LIFEX" />    
                        </ns0:ExternalReference>
                        
                        <ns0:DeliveryDate>
                            <xsl:value-of select="eit:createDate(E1EDT13[QUALF = '007']/NTANF)"/>
                        </ns0:DeliveryDate>
                        
                        <ns0:SenderReference>
                            <xsl:value-of select="distinct-values(E1EDL24[LFIMG > 0]/VGBEL)"/>
                        </ns0:SenderReference>
                        
                        <ns0:SenderAddress>
                            <ns0:Name>
                                <xsl:value-of select="substring(E1ADRM1[PARTNER_Q = 'LF']/NAME1, 1, 100)"/>
                            </ns0:Name>
                            <ns0:Name>
                                <xsl:value-of select="substring(E1ADRM1[PARTNER_Q = 'LF']/NAME2, 1, 100)"/>
                            </ns0:Name>
                            <ns0:Address>
                                <xsl:value-of select="substring(E1ADRM1[PARTNER_Q = 'LF']/STREET1, 1, 100)"/>
                            </ns0:Address>
                            <ns0:Address2>
                                <xsl:value-of select="substring(E1ADRM1[PARTNER_Q = 'LF']/STREET2, 1, 100)"/>
                            </ns0:Address2>
                            <ns0:City>
                                <xsl:value-of select="substring(E1ADRM1[PARTNER_Q = 'LF']/CITY1, 1, 30)"/>
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="substring(E1ADRM1[PARTNER_Q = 'LF']/POSTL_COD1, 1, 20)"/>
                            </ns0:PostCode>
                            <ns0:CountryRegionCode>
                                <xsl:value-of select="substring(E1ADRM1[PARTNER_Q = 'LF']/COUNTRY1, 1, 10)"/>
                            </ns0:CountryRegionCode>
                        </ns0:SenderAddress>
                        
                        <ns0:DocumentLines>
                            <xsl:for-each select="E1EDL24[LFIMG > 0]">
                                <ns0:DocumentLine>
                                    <ns0:ExternalNo>
                                        <xsl:value-of select="MATNR" />
                                    </ns0:ExternalNo>
                                    
                                    <ns0:Description>
                                        <xsl:value-of select="ARKTX" />
                                    </ns0:Description>
                                    
                                    <ns0:ExternalBatchNo>
                                        <xsl:value-of select="CHARG" />
                                    </ns0:ExternalBatchNo>
                                    
                                    <ns0:OrderQuantity>
                                         <xsl:value-of select="LFIMG" />
                                    </ns0:OrderQuantity>
                                    
                                    <xsl:if test="VRKME != 'PCE'">
                                        <ns0:OrderUnitofMeasureCode>
                                            <xsl:value-of select="VRKME" />
                                        </ns0:OrderUnitofMeasureCode>
                                    </xsl:if>
                                    
                                    <ns0:GrossWeight>
                                        <xsl:value-of select="BRGEW" />
                                    </ns0:GrossWeight>
                                    
                                    <ns0:NetWeight>
                                        <xsl:value-of select="NTGEW" />
                                    </ns0:NetWeight>
                                    
                                    <ns0:ProductionDate>
                                        <xsl:value-of select="eit:createDate(ZZE1DL24/ZZLIPS_HSDAT)" />
                                    </ns0:ProductionDate>
                                    
                                    <ns0:ExpirationDate>
                                        <xsl:variable name="expDateParts" select="tokenize(E1EDL15[ATNAM = 'LOBM_VFDAT']/ATWRT, '\.')"/>
                                        <xsl:value-of select="concat($expDateParts[3], '-', $expDateParts[2], '-', $expDateParts[1])" />
                                    </ns0:ExpirationDate>
                                    
                                    <ns0:InitialCarrierStatusCode>
                                        <xsl:value-of select="ZZE1DL24/ZZLIPS_BESTQ" />
                                    </ns0:InitialCarrierStatusCode>
                                    
                                    <ns0:CountryofOriginCode>
                                        <xsl:value-of select="E1EDL35/HERKL" />
                                    </ns0:CountryofOriginCode>
                                    
                                    <ns0:Attribute03>
                                        <xsl:value-of select="LICHN" />
                                    </ns0:Attribute03>
                                    
                                    <!--DOC INFO SET  -->
                                    <ns0:Attributes>
                                        <ns0:Attribute>
                                            <ns0:Code>
                                                <xsl:text>LINENO</xsl:text>
                                            </ns0:Code>
                                            <ns0:Value>
                                                <xsl:value-of select="POSNR" />
                                            </ns0:Value>
                                        </ns0:Attribute>
                                        <ns0:Attribute>
                                            <ns0:Code>
                                                <xsl:text>PARLINENO</xsl:text>
                                            </ns0:Code>
                                            <ns0:Value>
                                                <xsl:value-of select="HIPOS" />
                                            </ns0:Value>
                                        </ns0:Attribute>
                                        <ns0:Attribute>
                                            <ns0:Code>
                                                <xsl:text>PO_NO</xsl:text>
                                            </ns0:Code>
                                            <ns0:Value>
                                                <xsl:value-of select="VGBEL" />
                                            </ns0:Value>
                                        </ns0:Attribute>
                                        <ns0:Attribute>
                                            <ns0:Code>
                                                <xsl:text>POLINENO</xsl:text>
                                            </ns0:Code>
                                            <ns0:Value>
                                                <xsl:value-of select="VGPOS" />
                                            </ns0:Value>
                                        </ns0:Attribute>
                                    </ns0:Attributes>
                                </ns0:DocumentLine>
                            </xsl:for-each>
                        </ns0:DocumentLines>  
                    </ns0:Document>
                </xsl:for-each>  
            </ns0:Documents>
        </ns0:Message>
    </xsl:template>
</xsl:stylesheet>