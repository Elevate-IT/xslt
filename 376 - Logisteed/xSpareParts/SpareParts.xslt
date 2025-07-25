<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="3.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    <xsl:template match="/">
        <ns0:Message>
            <ns0:Header>
                <ns0:MessageID>
                    <xsl:value-of select="generate-id()" />
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
                <xsl:for-each select="MessageLines/Lines">
                    <xsl:if test="Line != ''">
                        <ns0:Document>
                            <ns0:DocumentDate>
                                <xsl:value-of select="replace(substring(Line, 764, 8),'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                            </ns0:DocumentDate>
                            
                            <ns0:PostingDate>
                                <xsl:value-of select="replace(substring(Line, 764, 8),'(\d{4})(\d{2})(\d{2})','$1-$2-$3')"/>
                            </ns0:PostingDate>
                            
                            <ns0:ExternalDocumentNo>
                                <xsl:value-of select="normalize-space(substring(Line, 16, 20))"/>
                            </ns0:ExternalDocumentNo>
                            
                            <ns0:ExternalReference>
                                <xsl:value-of select="normalize-space(substring(Line, 36, 20))"/>
                            </ns0:ExternalReference>
                            
                            <ns0:Ship-ToReference>
                                <xsl:value-of select="normalize-space(substring(Line, 56, 20))"/>
                            </ns0:Ship-ToReference>
                            
                            <ns0:BillToCustomer>
                                <ns0:EANCode>
                                    <xsl:value-of select="normalize-space(substring(Line, 76, 10))"/>
                                </ns0:EANCode>
                                <ns0:Name>
                                    <xsl:value-of select="normalize-space(substring(Line, 86, 35))"/>
                                </ns0:Name>
                                <ns0:Name2>
                                    <xsl:value-of select="normalize-space(substring(Line, 121, 35))"/>
                                </ns0:Name2>
                                <ns0:Address>
                                    <xsl:value-of select="normalize-space(substring(Line, 156, 35))"/>
                                </ns0:Address>
                                <ns0:Address2>
                                    <xsl:value-of select="normalize-space(substring(Line, 191, 35))"/>
                                </ns0:Address2>
                                <ns0:PostCode>
                                    <xsl:value-of select="normalize-space(substring(Line, 226, 10))"/>
                                </ns0:PostCode>
                                <ns0:City>
                                    <xsl:value-of select="normalize-space(substring(Line, 236, 35))"/>
                                </ns0:City>
                                <ns0:CountryCode>
                                    <xsl:value-of select="normalize-space(substring(Line, 271, 2))"/>
                                </ns0:CountryCode>
                                <ns0:Contact>
                                    <xsl:value-of select="normalize-space(substring(Line, 273, 70))"/>
                                </ns0:Contact>
                                <ns0:PhoneNo>
                                    <xsl:value-of select="normalize-space(substring(Line, 343, 30))"/>
                                </ns0:PhoneNo>
                            </ns0:BillToCustomer>
                            
                            <ns0:ShipToAddress>
                                <ns0:EANCode>
                                    <xsl:value-of select="normalize-space(substring(Line, 373, 10))"/>
                                </ns0:EANCode>
                                <ns0:Name>
                                    <xsl:value-of select="normalize-space(substring(Line, 383, 35))"/>
                                </ns0:Name>
                                <ns0:Name2>
                                    <xsl:value-of select="normalize-space(substring(Line, 418, 35))"/>
                                </ns0:Name2>
                                <ns0:Address>
                                    <xsl:value-of select="normalize-space(substring(Line, 453, 35))"/>
                                </ns0:Address>
                                <ns0:Address2>
                                    <xsl:value-of select="normalize-space(substring(Line, 488, 35))"/>
                                </ns0:Address2>
                                <ns0:PostCode>
                                    <xsl:value-of select="normalize-space(substring(Line, 523, 10))"/>
                                </ns0:PostCode>
                                <ns0:City>
                                    <xsl:value-of select="normalize-space(substring(Line, 533, 35))"/>
                                </ns0:City>
                                <ns0:CountryCode>
                                    <xsl:value-of select="normalize-space(substring(Line, 569, 2))"/>
                                </ns0:CountryCode>
                                <ns0:Contact>
                                    <xsl:value-of select="normalize-space(substring(Line, 570, 70))"/>
                                </ns0:Contact>
                                <ns0:PhoneNo>
                                    <xsl:value-of select="normalize-space(substring(Line, 640, 30))"/>
                                </ns0:PhoneNo>
                            </ns0:ShipToAddress>
                            
                            <!-- Transport Type
                                 <xsl:value-of select="normalize-space(substring(Line, 670, 4))"/> -->
                            
                            <!-- Service
                                 <xsl:value-of select="normalize-space(substring(Line, 674, 4))"/> -->
                            
                            <!-- <xsl:if test="substring(Line, 678, 5)!='     '">
                                <ns0:DocumentConditions>
                                    <ns0:DocumentCondition>
                                        <ns0:ConditionCode>
                                            <xsl:value-of select="normalize-space(substring(Line, 678, 5))"/>
                                        </ns0:ConditionCode>
                                    </ns0:DocumentCondition>
                                </ns0:DocumentConditions>
                            </xsl:if> -->
                            
                            <ns0:IncotermCode>
                                <xsl:value-of select="normalize-space(substring(Line, 678, 5))"/>
                            </ns0:IncotermCode>
                            
                            <xsl:if test="substring(Line, 683, 10)!='          '">
                                <ns0:ShippingAgent>
                                    <ns0:EANCode>
                                        <xsl:value-of select="normalize-space(substring(Line, 683, 10))"/>
                                    </ns0:EANCode>
                                </ns0:ShippingAgent>
                            </xsl:if>
                            
                            <!-- ISO Delivery terms
                                 <xsl:value-of select="normalize-space(substring(Line, 693, 3))"/> -->
                            
                            <!-- Delivery Term Place. Vacio
                                 <xsl:value-of select="normalize-space(substring(Line, 696, 30))"/> -->
                            
                            <!-- Transport account number > hoort bij Shipping agent ? 
                                 <xsl:value-of select="normalize-space(substring(Line, 726, 30))"/>  -->
                            
                            <ns0:DocumentPackages>
                                <ns0:DocumentPackage>
                                    <ns0:NumberofPackages>
                                        <xsl:value-of select="normalize-space(substring(Line, 772, 6))"/>
                                    </ns0:NumberofPackages>
                                    <ns0:PackageCode>
                                        <xsl:value-of select="normalize-space(substring(Line, 778, 4))"/>
                                    </ns0:PackageCode>
                                    <ns0:GrossWeight>
                                        <xsl:value-of select="normalize-space(substring(Line, 782, 11))"/>
                                    </ns0:GrossWeight>
                                    <ns0:Cubage>
                                        <xsl:value-of select="normalize-space(substring(Line, 793, 11))"/>
                                    </ns0:Cubage>
                                    <ns0:Length>
                                        <xsl:value-of select="normalize-space(substring(Line, 804, 4))"/>
                                    </ns0:Length>
                                    <ns0:Width>
                                        <xsl:value-of select="normalize-space(substring(Line, 808, 4))"/>
                                    </ns0:Width>
                                </ns0:DocumentPackage>
                            </ns0:DocumentPackages>
                            
                            <ns0:Quantity>
                                <xsl:value-of select="normalize-space(substring(Line, 812, 4))"/>
                            </ns0:Quantity>
                            
                            <ns0:Attributes>
                                <ns0:Attribute>
                                    <ns0:Code>EDIMSGTYPE</ns0:Code>
                                    <ns0:Value>DELIVERY_DELJIT_DESORD</ns0:Value>
                                </ns0:Attribute>
                            </ns0:Attributes>
                        </ns0:Document>
                    </xsl:if>
                </xsl:for-each>
            </ns0:Documents>
        </ns0:Message>
    </xsl:template>
</xsl:stylesheet>
