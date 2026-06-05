<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
                xmlns:tbox="http://connect1.transwise.eu/TboxService/"
                exclude-result-prefixes = "#all" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="soap:Envelope/soap:Body/tbox:carrierBooking"/>
    </xsl:template>
    
    <xsl:template match="tbox:carrierBooking">
        <ns0:Message>
            <ns0:Header>
                <ns0:CreationDateTime>
                    <xsl:value-of select="current-dateTime()" />
                </ns0:CreationDateTime>
                <ns0:ProcesAction>
                    <xsl:text>INSERT</xsl:text>
                </ns0:ProcesAction>
                <ns0:FromTradingPartner>
                    <xsl:text>BMS</xsl:text>
                </ns0:FromTradingPartner>
                <ns0:ToTradingPartner>
                    <xsl:text>Xwift</xsl:text>
                </ns0:ToTradingPartner>
            </ns0:Header>
            
            <xsl:apply-templates select="tbox:shipments"/>
        </ns0:Message>
    </xsl:template>
    
    <xsl:template match="tbox:shipments">
        <ns0:Documents>
            <xsl:apply-templates select="tbox:shipmentInfo"/>
        </ns0:Documents>
    </xsl:template>
    
    <xsl:template match="tbox:shipmentInfo">
        <ns0:Document>
            <ns0:DocumentDate>
                <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')" />
            </ns0:DocumentDate>
            
            <ns0:ExternalDocumentNo>
                <xsl:value-of select="tbox:reference"/>
            </ns0:ExternalDocumentNo>
            
            <ns0:ExternalReference>
                
            </ns0:ExternalReference>
            
            <ns0:OrderTypeCode>
                <xsl:text>CROSSDOCK</xsl:text>
            </ns0:OrderTypeCode>
            
            <ns0:ShippingAgentCode>
                <xsl:value-of select="tbox:carrier"/>    
            </ns0:ShippingAgentCode>
            
            <ns0:DepartedDate>
                <xsl:value-of select="tbox:pickupDate"/>    
            </ns0:DepartedDate>
            
            <ns0:DeliveryDate>
                
            </ns0:DeliveryDate>
            
            <ns0:AirwayBillNo>
                <xsl:value-of select="tbox:awb"/>    
            </ns0:AirwayBillNo>
            
            <xsl:apply-templates select="tbox:addresses/tbox:address[tbox:type = 'RECV']"/>
            <xsl:apply-templates select="tbox:addresses/tbox:address[tbox:type = 'SEND']"/>
            
            <xsl:apply-templates select="tbox:shipmentLines"/>
        </ns0:Document>
    </xsl:template>
    
    <xsl:template match="tbox:address[tbox:type = 'RECV']">
        <ns0:SenderAddress>
            <ns0:Name>
                <xsl:value-of select="tbox:name"/>
            </ns0:Name>
            <ns0:Address>
                <xsl:value-of select="tbox:street1"/>
            </ns0:Address>
            <ns0:Address2>
                <xsl:value-of select="tbox:street2"/>
            </ns0:Address2>
            <ns0:City>
                <xsl:value-of select="tbox:city"/>
            </ns0:City>
            <ns0:PostCode>
                <xsl:value-of select="tbox:zipCode"/>
            </ns0:PostCode>
            <ns0:CountryRegionCode>
                <xsl:value-of select="tbox:countryCode"/>
            </ns0:CountryRegionCode>
            <ns0:Contact>
                <xsl:value-of select="tbox:contact"/>
            </ns0:Contact>
            <ns0:PhoneNo>
                <xsl:value-of select="tbox:telNo"/>
            </ns0:PhoneNo>
            <ns0:FaxNo>
                <xsl:value-of select="tbox:faxNo"/>
            </ns0:FaxNo>
            <ns0:E-Mail>
                <xsl:value-of select="tbox:email"/>
            </ns0:E-Mail>
            <ns0:VATRegistrationNo>
                <xsl:value-of select="tbox:VATNumberh"/>
            </ns0:VATRegistrationNo>
        </ns0:SenderAddress>
    </xsl:template>
    
    <xsl:template match="tbox:address[tbox:type = 'SEND']">
        <ns0:ShipToAddress>
            <ns0:Name>
                <xsl:value-of select="tbox:name"/>
            </ns0:Name>
            <ns0:Address>
                <xsl:value-of select="tbox:street1"/>
            </ns0:Address>
            <ns0:Address2>
                <xsl:value-of select="tbox:street2"/>
            </ns0:Address2>
            <ns0:City>
                <xsl:value-of select="tbox:city"/>
            </ns0:City>
            <ns0:PostCode>
                <xsl:value-of select="tbox:zipCode"/>
            </ns0:PostCode>
            <ns0:CountryRegionCode>
                <xsl:value-of select="tbox:countryCode"/>
            </ns0:CountryRegionCode>
            <ns0:Contact>
                <xsl:value-of select="tbox:contact"/>
            </ns0:Contact>
            <ns0:PhoneNo>
                <xsl:value-of select="tbox:telNo"/>
            </ns0:PhoneNo>
            <ns0:FaxNo>
                <xsl:value-of select="tbox:faxNo"/>
            </ns0:FaxNo>
            <ns0:E-Mail>
                <xsl:value-of select="tbox:email"/>
            </ns0:E-Mail>
            <ns0:VATRegistrationNo>
                <xsl:value-of select="tbox:VATNumberh"/>
            </ns0:VATRegistrationNo>
        </ns0:ShipToAddress>
    </xsl:template>
    
    <xsl:template match="tbox:shipmentLines">
        <ns0:DocumentLines>
            <xsl:apply-templates select="tbox:shipmentLine"/>
        </ns0:DocumentLines>
    </xsl:template>
    
    <xsl:template match="tbox:shipmentLine">
        <ns0:DocumentLine>
            <ns0:No>
                <xsl:text>2979</xsl:text>
            </ns0:No>   
            
            <ns0:DocumentDetailLines>
                <ns0:DocumentDetailLine>
                    <ns0:CarrierNo>
                        <xsl:value-of select="tbox:awb"/>
                    </ns0:CarrierNo>

                    <ns0:OrderQuantity>
                        <xsl:value-of select="tbox:quantity"/>
                    </ns0:OrderQuantity>
                </ns0:DocumentDetailLine>
            </ns0:DocumentDetailLines>

        </ns0:DocumentLine>
    </xsl:template>
</xsl:stylesheet>