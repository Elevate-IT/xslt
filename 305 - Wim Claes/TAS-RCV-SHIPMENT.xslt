<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="3.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
    >
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    <xsl:key name="Group_by_PickingInstructions" match="DespatchData" use="PickingInstructions" />
    <xsl:template match="/">
        <xsl:apply-templates select="Dossiers/Dossier" />
    </xsl:template>
    <xsl:template match="Dossiers/Dossier">
        <ns0:Message>
            <ns0:Header>
                <ns0:MessageID>
                    <xsl:value-of select="substring-after(CallOffId, 'TAS_WIMCLAES_')" />
                </ns0:MessageID>
                <ns0:CreationDateTime>
                    <xsl:value-of select="current-dateTime()" />
                </ns0:CreationDateTime>
                <ns0:ProcesAction>
                    <xsl:text>INSERT</xsl:text>
                </ns0:ProcesAction>
                <ns0:FromTradingPartner>
                    <xsl:text>TAS</xsl:text>
                </ns0:FromTradingPartner>
                <ns0:ToTradingPartner>
                    <xsl:text>Wim Claes</xsl:text>
                </ns0:ToTradingPartner>
            </ns0:Header>
            <ns0:Documents>
                <xsl:for-each select="Missions/Mission">
                    <ns0:Document>
                        <!-- <ns0:BuildingCode>
                             </ns0:BuildingCode> -->
                        <ns0:DocumentDate>
                            <xsl:value-of select="xs:date(replace(/Dossiers/Dossier/Date, '([0-9]{4})/([0-9]{2})/([0-9]{2})', '$1-$2-$3')) "/>
                        </ns0:DocumentDate>
                        <!-- <ns0:PostingDate>
                             <xsl:value-of select="MyScript:ParseDate(DespatchData/CarrierRunDate, 'yyyyMMdd', 'yyyy-MM-dd')" />
                             </ns0:PostingDate> -->
                        <ns0:ExternalDocumentNo>
                            <xsl:value-of select="Dossiersr/Dossier/Reference" />
                        </ns0:ExternalDocumentNo>
                        
                        <ns0:ShippingAgent>
                            <ns0:ExternalNo>
                                <xsl:value-of select="Load/Number" />
                            </ns0:ExternalNo>
                            <ns0:Name>
                                <xsl:value-of select="Load/Name" />
                            </ns0:Name>
                            <ns0:Address>
                                <xsl:value-of select="concat(Load/Street,' ', Load/HouseNbr)" />
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="Load/City" />
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="Load/Zipcode" />
                            </ns0:PostCode>
                            <ns0:CountryCode>
                                <xsl:value-of select="Load/Country" />
                            </ns0:CountryCode>
                        </ns0:ShippingAgent>
                        
                        <ns0:OrderTypeCode>
                            <!-- <xsl:text>SMURFITKAPPA</xsl:text> -->
                        </ns0:OrderTypeCode>
                        
                        <ns0:ShipToAddress>
                            <ns0:ExternalNo>
                                <xsl:value-of select="Unload/Number" />
                            </ns0:ExternalNo>
                            <ns0:Name>
                                <xsl:value-of select="Unload/Name" />
                            </ns0:Name>
                            <ns0:Address>
                                <xsl:value-of select="concat(Unload/Street,' ', Unload/HouseNbr)" />
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="Unload/City" />
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="Unload/Zipcode" />
                            </ns0:PostCode>
                            <ns0:CountryCode>
                                <xsl:value-of select="Unload/Country" />
                            </ns0:CountryCode>
                        </ns0:ShipToAddress>
                        
                        <ns0:TripNo>
                            <xsl:value-of select="Tour/TourNumber" />
                        </ns0:TripNo>
                        <ns0:SequenceNo>
                            <xsl:value-of select="SequenceNumber" />
                        </ns0:SequenceNo>
                        
                        <!-- <ns0:Attributes>
                             <ns0:Attribute>
                             <ns0:Code>
                             <xsl:text>SK_CUSTID</xsl:text>
                             </ns0:Code>
                             <ns0:Value>
                             <xsl:value-of select="//CustomerId"/>
                             </ns0:Value>
                             </ns0:Attribute>
                             </ns0:Attributes> -->
                        
                        <ns0:DocumentLines>
                            <xsl:for-each select="Products/Product">
                                <!-- <xsl:variable name="DeliveryLineID" select="DeliveryLineId" /> -->
                                <ns0:DocumentLine>
                                    <ns0:No>
                                        <xsl:value-of select="/Dossiers/Dossier/Customer" />
                                    </ns0:No>
                                    <ns0:OrderQuantity>
                                        <xsl:value-of select="Colli" />
                                    </ns0:OrderQuantity>
                                    <ns0:Weight>
                                        <xsl:value-of select="Weight" />
                                    </ns0:Weight>
                                    <!-- <ns0:CustomerNo>
                                         <xsl:value-of select="/Dossiers/Dossier/Customer" />
                                         
                                         </ns0:CustomerNo> -->
                                    <ns0:Description>
                                        <xsl:value-of select="Description" />
                                    </ns0:Description>
                                    <ns0:UnitofMeasureCode>
                                        <xsl:value-of select="Packaging" />
                                    </ns0:UnitofMeasureCode>
                                    <ns0:GrossWeight>
                                        <xsl:value-of select="Weight" />
                                    </ns0:GrossWeight>
                                    <!-- <ns0:OrderUnitofMeasureCode>
                                         <xsl:value-of select="Packaging" />
                                         </ns0:OrderUnitofMeasureCode> -->
                                    
                                    
                                    <xsl:for-each select="Productdetails/Productdetail">
                                        
                                        
                                        <ns0:DocumentDetailLines>
                                            <ns0:DocumentDetailLine>
                                                <ns0:CarrierNo>
                                                    <xsl:value-of select="Barcode" />
                                                </ns0:CarrierNo>
                                            </ns0:DocumentDetailLine>
                                        </ns0:DocumentDetailLines>
                                    </xsl:for-each>
                                </ns0:DocumentLine>
                            </xsl:for-each>
                        </ns0:DocumentLines>
                        
                    </ns0:Document>
                </xsl:for-each>
            </ns0:Documents>
        </ns0:Message>
    </xsl:template>
</xsl:stylesheet>