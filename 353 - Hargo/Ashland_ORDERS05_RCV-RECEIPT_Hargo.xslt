<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes = "#all" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>

    <xsl:variable name="EUCountryCodes" select="tokenize('AT BE BG CY CZ DE DK EE ES FI FR GR HR HU IE IT LT LU LV MC MT NL PL PT RO SE SI SK', '\s+')" />
    
    <xsl:key name="GroupedDocumentLines" match="//E1EDP01[MENGE > 0]" 
        use="concat(E1EDP19[QUALF = '001']/IDTNR, '-', ../E1EDK01/BELNR, '-', MENEE, '-', WERKS, '-', ../E1EDK01/BELNR)" />
    
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
                <xsl:for-each select="/ORDERS05/IDOC">
                    <ns0:Document>
                        <ns0:DocumentDate>
                            <xsl:value-of select="format-date(current-date(), '[D,2]/[M,2]/[Y]')"/>
                        </ns0:DocumentDate>
                        
                        <ns0:ExternalDocumentNo>
                            <xsl:value-of select="format-number(E1EDK01/BELNR, '#')"/>
                        </ns0:ExternalDocumentNo>
                        
                        <ns0:ExternalReference>
                            <xsl:value-of select="E1EDT20/TKNUM" />
                        </ns0:ExternalReference>
                        
                        <xsl:variable name="OrderType2">
                            <xsl:choose>
                                <xsl:when test="E1EDP01[MENGE > 0][1]/WERKS = '5623'">
                                    <xsl:text>ZENDING</xsl:text>
                                </xsl:when>
                                <xsl:when test="index-of($EUCountryCodes, E1EDKA1[PARVW = 'LF']/LAND1)">
                                    <xsl:text>TRUCK EU</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>TRUCK NON-EU</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <ns0:OrderTypeCode>
                            <xsl:value-of select="$OrderType2"/>
                        </ns0:OrderTypeCode>
                        
                        <ns0:DeliveryDate>
                            <xsl:choose>
                                <xsl:when test="E1EDT20/E1EDL20[1]/ZSHPMNT/ZZ_ARRV_DT &gt; 0">
                                    <xsl:value-of select="E1EDT20/E1EDL20[1]/ZSHPMNT/ZZ_ARRV_DT"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="E1EDT20/E1EDT10[QUALF = '005']/NTEND"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ns0:DeliveryDate>
                        
                        <ns0:BillofLadingNo>
                            <xsl:value-of select="E1EDT20/TKNUM"/>
                        </ns0:BillofLadingNo>
                        
                        
                        <!-- Douane -->
                        
                        <ns0:IncotermCode>
                            <xsl:value-of select="E1EDK17[QUALF = '001']/LKOND" />
                        </ns0:IncotermCode>
                        
                        <ns0:IncotermCity>
                            <xsl:value-of select="E1EDK17[QUALF = '001']/LKTEXT" />
                        </ns0:IncotermCity>
                        
                        <ns0:SenderAddress>
                            <!-- <ns0:No>
                                 <xsl:value-of select="number(E1EDKA1[PARVW = 'LF']/PARTN)"/>
                                 </ns0:No> -->
                            <ns0:Name>
                                <xsl:value-of select="substring(E1EDKA1[PARVW = 'LF']/NAME1, 1, 100)"/>
                            </ns0:Name>
                            <ns0:Address>
                                <xsl:value-of select="substring(E1EDKA1[PARVW = 'LF']/STRAS, 1, 100)"/>
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="substring(E1EDKA1[PARVW = 'LF']/ORT01, 1, 30)"/>
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="substring(E1EDKA1[PARVW = 'LF']/PSTLZ, 1, 20)"/>
                            </ns0:PostCode>
                            <ns0:CountryRegionCode>
                                <xsl:value-of select="substring(E1EDKA1[PARVW = 'LF']/LAND1, 1, 10)"/>
                            </ns0:CountryRegionCode>
                            <ns0:Attribute10>
                                <xsl:value-of select="number(E1EDKA1[PARVW = 'LF']/PARTN)"/>
                            </ns0:Attribute10>
                        </ns0:SenderAddress>
                        
                        <ns0:Attribute04>
                            <!-- <xsl:choose>
                                 <xsl:when test="E1EDT20/E1EDL20[1]/E1EDL21/LFART = 'NLCC'">
                                 <xsl:text>109</xsl:text>
                                 </xsl:when>
                                 <xsl:otherwise>
                                 <xsl:text>101</xsl:text>
                                 </xsl:otherwise>
                                 </xsl:choose> -->
                         </ns0:Attribute04>
                        
                        <ns0:DocumentLines>
                            <xsl:for-each select="E1EDP01[MENGE > 0][count(. | key('GroupedDocumentLines', concat(E1EDP19[QUALF = '001']/IDTNR, '-', ../E1EDK01/BELNR, '-', MENEE, '-', WERKS, '-', ../E1EDK01/BELNR))[1]) = 1]">
                                <xsl:variable name="LineKey" select="concat(E1EDP19[QUALF = '001']/IDTNR, '-', ../E1EDK01/BELNR, '-', MENEE, '-', WERKS, '-', ../E1EDK01/BELNR)" />
                                <xsl:if test="$LineKey != '----'">
                                    <ns0:DocumentLine>
                                        
                                        <ns0:ExternalNo>
                                            <xsl:value-of select="number(E1EDP19[QUALF = '001']/IDTNR)" />
                                        </ns0:ExternalNo>
                                        
                                        <ns0:Description>
                                            <xsl:value-of select="E1EDP19[QUALF = '001']/KTEXT" />
                                        </ns0:Description>
                                        
                                        <!-- <ns0:ExternalBatchNo>
                                             <xsl:value-of select="CHARG" />
                                             </ns0:ExternalBatchNo>    -->
                                        
                                        <ns0:OrderQuantity>
                                            <xsl:value-of select="sum(key('GroupedDocumentLines', $LineKey)/MENGE)" />
                                        </ns0:OrderQuantity>
                                        
                                        <ns0:OrderUnitofMeasureCode>
                                            <xsl:value-of select="MENEE" />
                                        </ns0:OrderUnitofMeasureCode>
                                        
                                        <ns0:GrossWeight>
                                            <xsl:value-of select="sum(key('GroupedDocumentLines', $LineKey)/BRGEW)" />
                                        </ns0:GrossWeight>
                                        
                                        <ns0:NetWeight>
                                            <xsl:value-of select="sum(key('GroupedDocumentLines', $LineKey)/NTGEW)" />
                                        </ns0:NetWeight>
                                        
                                        <!-- <ns0:CountryofOriginCode>
                                             <xsl:value-of select="E1EDL35/E1EDL36/HERKL_BEZ" />
                                             </ns0:CountryofOriginCode> -->
                                        
                                        <ns0:CustomsCode>
                                            <xsl:choose>
                                                <xsl:when test="(WERKS = '5622') and ($OrderType2 != 'TRUCK EU')">
                                                    <xsl:text>CLEARED</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="(WERKS = '5623')">
                                                    <xsl:text>CLEARED</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="WERKS = '5610'">
                                                    <xsl:text>BONDED</xsl:text>
                                                </xsl:when>
                                            </xsl:choose>
                                        </ns0:CustomsCode>
                                        
                                        <ns0:Attribute06>
                                            <xsl:value-of select="../E1EDK01/BELNR" />
                                        </ns0:Attribute06>
                                        
                                        <ns0:Attribute01>
                                            <!-- <xsl:value-of select="../VBELN" /> -->
                                        </ns0:Attribute01>
                                        
                                        <ns0:ExternalDocumentNo>
                                            <xsl:value-of select="format-number(../E1EDK01/BELNR, '#')"/>
                                        </ns0:ExternalDocumentNo>
                                        
                                        <!--  DOC INFO SET  -->
                                        <ns0:Attributes>
                                            <!-- <ns0:Attribute>
                                                <ns0:Code>
                                                    <xsl:text>LineNo</xsl:text>
                                                </ns0:Code> 
                                                <ns0:Value>
                                                    <xsl:value-of select="POSEX" /> Removed to allow for grouping
                                                </ns0:Value>
                                            </ns0:Attribute> -->
                                        </ns0:Attributes>
                                    </ns0:DocumentLine>
                                </xsl:if>
                            </xsl:for-each>
                        </ns0:DocumentLines>  
                    </ns0:Document>
                </xsl:for-each>  
            </ns0:Documents>
        </ns0:Message>
    </xsl:template>
</xsl:stylesheet>