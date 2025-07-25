<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes = "#all" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:variable name="EUCountryCodes" select="tokenize('AT BE BG CY CZ DE DK EE ES FI FR GR HR HU IE IT LT LU LV MC MT NL PL PT RO SE SI SK', '\s+')" />
    
    <xsl:variable name="OrderType">
        <xsl:choose>
            <xsl:when test="E1EDL20/E1EDL24[LFIMG &gt; 0][1]/WERKS = '5623'">
                <xsl:text>ZENDING</xsl:text>
            </xsl:when>
            <xsl:when test="upper-case(/ZDLVRY/IDOC/E1EDL20/E1EDL22/VSBED_BEZ) = 'MARINE'">
                <xsl:text>SEA</xsl:text>
            </xsl:when>
            <xsl:when test="upper-case(/ZDLVRY/IDOC/E1EDL20/E1EDL22/VSBED_BEZ) = 'LCL'">
                <xsl:text>SEA</xsl:text>
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
            <xsl:when test="upper-case(/ZDLVRY/IDOC/E1EDL20/E1EDL22/VSBED_BEZ) = 'FULL TRUCK LOAD'">
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
                <ns0:Information>
                    <xsl:value-of select="/ZDLVRY/IDOC/E1EDL20/E1EDL18/QUALF"/>
                </ns0:Information>
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
                        
                        <ns0:Ship-ToReference>
                            <xsl:value-of select="substring(E1EDL20/E1EDL24[LFIMG &gt; 0][1]/E1EDL41/BSTNR, 1, 20)"/>
                        </ns0:Ship-ToReference>
                        
                        <ns0:OrderTypeCode>
                            <xsl:choose>
                                <xsl:when test="($OrderType = 'TRUCK')">
                                    <xsl:choose>
                                        <xsl:when test="index-of($EUCountryCodes, E1EDL20/E1ADRM1[PARTNER_Q = 'WE']/COUNTRY1)">
                                            <xsl:text>TRUCK EU</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>TRUCK NON-EU</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$OrderType"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ns0:OrderTypeCode>                        
                        
                        <ns0:DeliveryDate>
                            <xsl:value-of select="E1EDL20/E1EDT13[QUALF = 'xxx']/NTANF"/>
                        </ns0:DeliveryDate>
                        
                        <xsl:if test="E1EDL20/INCO1 != 'FCA' and $OrderType != 'SEA'">
                            <ns0:EstimatedDepartureDate>
                                <xsl:value-of select="E1EDL20/E1EDT13[QUALF = '003']/NTANF"/>
                            </ns0:EstimatedDepartureDate>
                        </xsl:if>
                        
                        <!-- Douane -->                        
                        <ns0:IncotermCode>
                            <xsl:value-of select="E1EDL20/INCO1" />
                        </ns0:IncotermCode>
                        
                        <ns0:IncotermCity>
                            <xsl:value-of select="E1EDL20/INCO2" />
                        </ns0:IncotermCity>
                        
                        <ns0:ShipToAddress>
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
                            <ns0:Attribute10>
                                <xsl:value-of select="substring(E1EDL20/E1ADRM1[PARTNER_Q = 'WE']/PARTNER_ID, 1, 30)"/>
                            </ns0:Attribute10>
                        </ns0:ShipToAddress>
                        
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
                        
                        <ns0:DocumentComments>
                            <xsl:for-each select="E1EDL20/E1EDL24[LFIMG = 0]/Z1EDLTM[PALLET_TYPE != '']">
                                <xsl:variable name="PalTypeHeader">
                                    <xsl:choose>
                                        <xsl:when test="substring(PALLET_TYPE, 1, 2) = 'C1'">
                                            <xsl:text>CP1</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="substring(PALLET_TYPE, 1, 2) = 'C3'">
                                            <xsl:text>CP3</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="substring(PALLET_TYPE, 1, 2) = 'EU'">
                                            <xsl:text>EUR</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="substring(PALLET_TYPE, 1, 2) = 'IB'">
                                            <xsl:text>IBC</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="substring(PALLET_TYPE, 1, 2) = 'T4'">
                                            <xsl:text>CP4</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring(PALLET_TYPE, 1, 2)" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <ns0:DocumentComment>
                                    <ns0:Code>INSTRUCTIES</ns0:Code>
                                    <ns0:Comment>
                                        <xsl:value-of select="concat('Type: ', substring(PALLET_TYPE, 1, 2), ', Qty: ', PALLET_NOS, ', Stackable: ', STACKBLE, ', Height: ', substring(PALLET_TYPE, 3))" />
                                    </ns0:Comment>
                                </ns0:DocumentComment>
                            </xsl:for-each>
                        </ns0:DocumentComments>
                        
                        <ns0:Attributes>
                            <xsl:if test="count(E1EDL20/E1EDL24/Z1EDLTM[PALLET_NOS != '']) &gt; 0">
                                <ns0:Attribute>
                                    <ns0:Code>AANTALPALS</ns0:Code>
                                    <ns0:Value>
                                        <xsl:value-of select="sum(E1EDL20/E1EDL24/Z1EDLTM[PALLET_NOS != '']/PALLET_NOS)" />
                                    </ns0:Value>
                                </ns0:Attribute>
                            </xsl:if>
                        </ns0:Attributes>
                        
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
                                                <!-- <xsl:text>CLEARED</xsl:text> --><!-- removed, Monday action list 747 -->
                                            </xsl:when>
                                            <xsl:when test="WERKS = '5610'">
                                                <xsl:text>BONDED</xsl:text>
                                            </xsl:when>
                                        </xsl:choose>
                                    </ns0:CustomsCode>
                                    
                                    <ns0:OrderQuantity>
                                        <xsl:value-of select="LFIMG" />
                                    </ns0:OrderQuantity>
                                    
                                    <ns0:OrderUnitofMeasureCode>
                                        <xsl:value-of select="VRKME" />
                                    </ns0:OrderUnitofMeasureCode>
                                    
                                    <ns0:GrossWeight>
                                        <xsl:value-of select="BRGEW" />
                                    </ns0:GrossWeight>
                                    
                                    <ns0:NetWeight>
                                        <xsl:value-of select="LGMNG" />
                                    </ns0:NetWeight>
                                    
                                    <ns0:CarrierTypeCode>
                                        <xsl:choose>
                                            <xsl:when test="Z1EDLTM/PALLET_TYPE != ''">
                                                <xsl:value-of select="substring(Z1EDLTM/PALLET_TYPE, 1, 2)" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:choose>
                                                    <xsl:when test="count(../E1EDL24[LFIMG = 0]/Z1EDLTM[PALLET_TYPE != '']) = 1">
                                                        <xsl:value-of select="substring(../E1EDL24[LFIMG = 0]/Z1EDLTM/PALLET_TYPE, 1, 2)" />
                                                    </xsl:when>
                                                    <xsl:when test="count(../E1EDL24[LFIMG = 0]/Z1EDLTM[PALLET_TYPE != '']) &gt; 1">
                                                        <xsl:if test="count(../E1EDL24[LFIMG = 0]/Z1EDLTM[substring(PALLET_TYPE, 1, 2) = 'IB']) &gt; 0">
                                                            <xsl:choose>
                                                                <xsl:when test="VRKME = 'IBC'">
                                                                    <xsl:text>IB</xsl:text>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:if test="count(../E1EDL24[LFIMG = 0]/Z1EDLTM[not(starts-with(PALLET_TYPE, 'IB'))][PALLET_TYPE != '']) = 1">
                                                                        <xsl:value-of select="substring(../E1EDL24[LFIMG = 0]/Z1EDLTM[not(starts-with(PALLET_TYPE, 'IB'))]/PALLET_TYPE, 1, 2)" />
                                                                    </xsl:if>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:if>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </ns0:CarrierTypeCode>
                                    
                                    <ns0:CarrierQuantity>
                                        <xsl:value-of select="Z1EDLTM/PALLET_NOS" />
                                    </ns0:CarrierQuantity>
                                    
                                    <ns0:Attribute01>
                                        <xsl:value-of select="../VBELN" />
                                    </ns0:Attribute01>
                                    
                                    <ns0:Attribute06>
                                        <xsl:value-of select="VGBEL" />
                                    </ns0:Attribute06>
                                    
                                    <ns0:Attribute10>
                                        <xsl:value-of select="substring(LGORT, 1, 2)" />
                                    </ns0:Attribute10>
                                    
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
                                        <ns0:Attribute>
                                            <ns0:Code>
                                                <xsl:text>POLineNo</xsl:text>
                                            </ns0:Code>
                                            <ns0:Value>
                                                <xsl:value-of select="VGPOS" />
                                            </ns0:Value>
                                        </ns0:Attribute>
                                    </ns0:Attributes>
                                    
                                    <ns0:DocumentLineComments>
                                        <xsl:if test="Z1EDLTM/PALLET_TYPE != ''">
                                            <ns0:DocumentLineComment>
                                                <ns0:Code>INSTRUCTIES</ns0:Code>
                                                <ns0:Comment>
                                                    <xsl:value-of select="concat(number(MATNR), ', Type: ', substring(Z1EDLTM/PALLET_TYPE, 1, 2), ', Qty: ', Z1EDLTM/PALLET_NOS, ', Stackable: ', Z1EDLTM/STACKBLE, ', Height: ', substring(Z1EDLTM/PALLET_TYPE, 3))" />
                                                </ns0:Comment>
                                            </ns0:DocumentLineComment>
                                        </xsl:if>
                                    </ns0:DocumentLineComments>
                                </ns0:DocumentLine>
                            </xsl:for-each>
                        </ns0:DocumentLines>  
                    </ns0:Document>
                </xsl:for-each>  
            </ns0:Documents>
        </ns0:Message>
    </xsl:template>
</xsl:stylesheet>