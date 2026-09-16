<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
                exclude-result-prefixes = "#all" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:template match="/Rows">
        <Message>
            <xsl:call-template name="header" />
            
            <Documents>
                <xsl:for-each-group select="Row[position() > 1]" group-by="Colomn2">
                    <xsl:call-template name="document">
                        <xsl:with-param name="data" select="."/>
                    </xsl:call-template>
                </xsl:for-each-group>
            </Documents>
        </Message>
    </xsl:template>
    
    <xsl:template name="header">
        <Header>
            <CreationDateTime>
                <xsl:value-of select="current-dateTime()" />
            </CreationDateTime>
            <ProcesAction>
                <xsl:text>INSERT</xsl:text>
            </ProcesAction>
            <FromTradingPartner>
                <xsl:text>K0059</xsl:text>
            </FromTradingPartner>
            <ToTradingPartner>
                <xsl:text>Xwift</xsl:text>
            </ToTradingPartner>
        </Header>
    </xsl:template>
    
    <xsl:template name="document">
        <xsl:param name="data" />

        <Document>
            <DocumentDate>
                <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')" />
            </DocumentDate>            
            <ExternalDocumentNo>
                <xsl:value-of select="$data/Colomn2"/>
            </ExternalDocumentNo>            
            <ExternalReference>
                <xsl:value-of select="$data/Colomn2"/>
            </ExternalReference>
            <ShippingAgentCode>
                <xsl:text>DISTRI</xsl:text>
            </ShippingAgentCode>
            
            <ShipToAddress>
                <Name>
                    <xsl:value-of select="substring($data/Colomn14, 1, 100)"/>
                </Name>
                <Address>
                    <xsl:value-of select="substring($data/Colomn16, 1, 100)"/>
                </Address>
                <City>
                    <xsl:value-of select="substring($data/Colomn13, 1, 30)"/>
                </City>
                <PostCode>
                    <xsl:value-of select="$data/Colomn17"/>
                </PostCode>
                <CountryRegionCode>
                    <xsl:text>BE</xsl:text>
                </CountryRegionCode>
            </ShipToAddress>
            
            <DocumentLines>
                <xsl:for-each select="current-group()">
                    <DocumentLine>
                        <No>
                            <xsl:value-of select="Colomn12"/>
                        </No>
                        <OrderQuantity>
                            <xsl:value-of select="Colomn10"/>
                        </OrderQuantity>
                        <ExternalBatchNo>
                            <xsl:value-of select="Colomn2"/>
                        </ExternalBatchNo>
                        <CommentText>
                            <xsl:value-of select="Colomn2"/>
                        </CommentText>
                    </DocumentLine>
                </xsl:for-each>
            </DocumentLines>
        </Document>
    </xsl:template>
</xsl:stylesheet>