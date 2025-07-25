<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/receivefreecirculation:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes = "#all" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:variable name="EUCountryCodes" select="tokenize('AT BE BG CY CZ DE DK EE ES FI FR GR HR HU IE IT LT LU LV MC MT NL PL PT RO SE SI SK', '\s+')" />
    
    <xsl:variable name="OrderType">
        <xsl:choose>
            <xsl:when test="upper-case(/ZDLVRY/IDOC/E1EDL20/E1EDL22/VSBED_BEZ) = 'MARINE'">
                <xsl:text>CONTAINER</xsl:text>
            </xsl:when>
            <xsl:when test="upper-case(/ZDLVRY/IDOC/E1EDL20/E1EDL22/VSBED_BEZ) = 'AIR'">
                <xsl:text>LUCHTVRACHT</xsl:text>
            </xsl:when>
            <xsl:when test="upper-case(/ZDLVRY/IDOC/E1EDL20/E1EDL22/VSBED_BEZ) = 'TRUCK'">
                <xsl:text>TRUCK</xsl:text>
            </xsl:when>
            <xsl:when test="upper-case(/ZDLVRY/IDOC/E1EDL20/E1EDL22/VSBED_BEZ) = 'LTL'">
                <xsl:text>TRUCK</xsl:text>
            </xsl:when>
            <xsl:when test="upper-case(/ZDLVRY/IDOC/E1EDL20/E1EDL22/VSBED_BEZ) = 'CUSTOMER PICKUP'">
                <xsl:text>TRUCK</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="upper-case(/ZDLVRY/IDOC/E1EDL20/E1EDL22/VSBED_BEZ)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="/">
        <ns0:Message>
            <ns0:Header>
                <!-- <ns0:MessageID>
                     <xsl:value-of select="substring-after(CallOffId, 'TAS_WIMCLAES_')" />
                     </ns0:MessageID> -->
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
                <xsl:for-each select="/ZDLVRY/IDOC">
                    <ns0:Document>
                        <ns0:DocumentDate>
                            <xsl:value-of select="format-date(current-date(), '[D,2]/[M,2]/[Y]')"/>
                        </ns0:DocumentDate>
                        
                        <ns0:ExternalDocumentNo>
                            <xsl:value-of select="format-number(E1EDL20/VBELN, '#')"/>
                        </ns0:ExternalDocumentNo>
                        
                        <ns0:OrderTypeCode>
                            <xsl:text>STO</xsl:text>
                        </ns0:OrderTypeCode>
                        
                        <xsl:if test="$OrderType = 'CONTAINER' ">
                            <ns0:VesselNo>
                                <!-- Mogelijk om deze mee te sturen?   -->
                            </ns0:VesselNo>
                        </xsl:if>
                        
                        
                        <ns0:DeliveryDate>
                            <xsl:value-of select="E1EDL20/E1EDT13[QUALF = 'xxx']/NTANF"/>
                        </ns0:DeliveryDate>
                        
                        
                        <xsl:if test="$OrderType = 'CONTAINER'">
                            <!-- Mogelijk om deze mee te sturen?   -->
                            <!-- <ns0:GrossWeight>
                                 <xsl:value-of select="E1EDT20/E1EDL20/BTGEW"/>
                                 </ns0:GrossWeight>
                                 <ns0:Quantity>
                                 <xsl:value-of select="sum(E1EDT20/E1EDL20/E1EDL24/LFIMG)"/>
                                 </ns0:Quantity>
                                 <ns0:ContainerNo>
                                 <xsl:value-of select="E1EDT20/SIGNI" />
                                 </ns0:ContainerNo>
                                 <ns0:ContainerSizeCode>
                                 <xsl:value-of select="E1EDT20/E1EDL20/ZSHPMNT/ZZEQ_TYPE" />
                                 </ns0:ContainerSizeCode>
                                 <ns0:SealNo>
                                 <xsl:value-of select="E1EDT20/E1TXTH6/E1TXTP6/TDLINE" />
                                 </ns0:SealNo> -->
                         </xsl:if>
                        
                        <!-- Douane -->                        
                        <ns0:IncotermCode>
                            <xsl:value-of select="E1EDL20/INCO1" />
                        </ns0:IncotermCode>
                        
                        <ns0:IncotermCity>
                            <xsl:value-of select="E1EDL20/INCO2" />
                        </ns0:IncotermCity>
                        
                        <ns0:ShippingAddress>
                            <ns0:No>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'WE']/PARTNER_ID, 1, 20)"/>
                            </ns0:No>
                            <ns0:Name>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'WE']/NAME1, 1, 100)"/>
                            </ns0:Name>
                            <ns0:Address>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'WE']/STREET1, 1, 100)"/>
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'WE']/CITY1, 1, 30)"/>
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'WE']/POSTL_COD1, 1, 20)"/>
                            </ns0:PostCode>
                            <ns0:CountryRegionCode>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'WE']/COUNTRY1, 1, 10)"/>
                            </ns0:CountryRegionCode>
                        </ns0:ShippingAddress>
                        
                        <ns0:ShippingAgent>
                            <ns0:No>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'OSP']/PARTNER_ID, 1, 20)"/>
                            </ns0:No>
                            <ns0:Name>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'OSP']/NAME1, 1, 100)"/>
                            </ns0:Name>
                            <ns0:Address>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'OSP']/STREET1, 1, 100)"/>
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'OSP']/CITY1, 1, 30)"/>
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'OSP']/POSTL_COD1, 1, 20)"/>
                            </ns0:PostCode>
                            <ns0:CountryRegionCode>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'OSP']/COUNTRY1, 1, 10)"/>
                            </ns0:CountryRegionCode>
                        </ns0:ShippingAgent> 
                        
                        <ns0:DocumentLines>
                            <xsl:for-each select="E1EDL20/E1EDL24[LFIMG &gt; 0]">
                                <ns0:DocumentLine>
                                    
                                    <ns0:ExternalNo>
                                        <xsl:value-of select="number(MATNR)" />
                                    </ns0:ExternalNo>
                                    
                                    <ns0:Description>
                                        <xsl:value-of select="ARKTX" />
                                    </ns0:Description>
                                    
                                    <ns0:ExternalBatchNo>
                                        <xsl:value-of select="CHARG" />
                                    </ns0:ExternalBatchNo>
                                    
                                    <ns0:CustomsCode>
                                        <xsl:choose>
                                            <xsl:when test="WERKS = '5622'">
                                                <xsl:text>CLEARED</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="WERKS = '5610'">
                                                <xsl:text>BONDED</xsl:text>
                                            </xsl:when>
                                        </xsl:choose>
                                    </ns0:CustomsCode>
                                    
                                    <ns0:OrderQuantity>
                                        <xsl:value-of select="LFIMG" />
                                    </ns0:OrderQuantity>
                                    
                                    <ns0:GrossWeight>
                                        <xsl:value-of select="BRGEW" />
                                    </ns0:GrossWeight>
                                    
                                    <ns0:NetWeight>
                                        <xsl:value-of select="LGMNG" />
                                    </ns0:NetWeight>
                                    
                                    <ns0:Attribute06>
                                        <xsl:value-of select="VGBEL" />
                                    </ns0:Attribute06>

                                    <!--DOC INFO SET  -->
                                    <ns0:Attributes>
                                        <ns0:Attribute>
                                            <ns0:Code>
                                                <xsl:text>LineNo</xsl:text>
                                            </ns0:Code> 
                                            <ns0:Value>
                                                <xsl:value-of select="POSNR" />
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