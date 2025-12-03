<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes = "#all" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:key name="GroupedDocumentLines" match="//E1EDT20/E1EDL20/E1EDL24[LFIMG > 0][number(MATNR) != 36462]" 
        use="concat(MATNR, '-', CHARG, '-', ../E1ADRM1[PARTNER_Q = 'WE']/PARTNER_ID, '-', VGBEL, '-', ../VBELN, '-', VRKME, '-', E1EDL35/HERKL, '-', VGPOS)" />
    
    <xsl:key name="GroupedBy_PONumbers" match="//E1EDT20/E1EDL20/E1EDL24[LFIMG > 0][number(MATNR) != 36462]" 
        use="VGBEL" />
    
    <xsl:variable name="OrderType" select="upper-case(/ZSHPMNT05/IDOC/E1EDT20/E1EDT22/VSART_BEZ)"/>
    <xsl:variable name="ContainerNo" select="translate(/ZSHPMNT05/IDOC/E1EDT20/SIGNI, '-', '')"/>
    <xsl:variable name="EUCountryCodes" select="tokenize('AT BE BG CY CZ DE DK EE ES FI FR GR HR HU IE IT LT LU LV MC MT NL PL PT RO SE SI SK', '\s+')" />
    
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
                <xsl:for-each select="/ZSHPMNT05/IDOC">
                    <ns0:Document>
                        <ns0:DocumentDate>
                            <xsl:value-of select="format-date(current-date(), '[D,2]/[M,2]/[Y]')"/>
                        </ns0:DocumentDate>
                        
                        <ns0:ExternalDocumentNo>
                            <xsl:value-of select="format-number(E1EDT20/TKNUM, '#')" />
                        </ns0:ExternalDocumentNo>
                        
                        <ns0:ExternalReference>
                            <xsl:variable name="PONumbers" >
                                <xsl:value-of select="E1EDT20/E1EDL20/E1EDL24[LFIMG > 0][number(MATNR) != 36462][count(. | key('GroupedBy_PONumbers', VGBEL)[1]) = 1]/VGBEL"/>
                            </xsl:variable>
                            <xsl:value-of select="substring(replace($PONumbers, ' ', '-'), 1, 80)" />
                        </ns0:ExternalReference>
                        
                        <xsl:variable name="OrderType2">
                            <xsl:choose>
                                <xsl:when test="E1EDT20/E1EDL20[1]/E1ADRM1[PARTNER_Q = 'WE']/PARTNER_ID = 'X5623'">
                                    <xsl:text>ZENDING</xsl:text>
                                </xsl:when>
                                <xsl:when test="($OrderType = 'SEA')">
                                    <xsl:variable name="checkedContainerNo" select="analyze-string($ContainerNo, '([a-zA-Z]{3})([UJZujz])(\d{6})(\d)')"/> <!-- check containerno format with regex -->
                                    <xsl:choose>
                                        <xsl:when test="$checkedContainerNo != ''">
                                            <xsl:text>CONTAINER</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>SEA</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="($OrderType = 'AIR')">
                                    <xsl:text>LUCHTVRACHT</xsl:text>
                                </xsl:when>
                                <xsl:when test="($OrderType = 'TRUCK')">
                                    <xsl:choose>
                                        <xsl:when test="index-of($EUCountryCodes, E1EDT20/E1EDL20[1]/E1ADRM1[PARTNER_Q = 'OSP']/COUNTRY1)">
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
                        </xsl:variable>
                        <ns0:OrderTypeCode>
                            <xsl:value-of select="$OrderType2"/>
                        </ns0:OrderTypeCode>
                        
                        <xsl:if test="($OrderType = 'SEA') or ($OrderType = 'LCL') ">
                            <xsl:variable name="VesselNo">
                                <xsl:choose>
                                    <xsl:when test="contains(E1EDT20/E1EDL20[1]/ZSHPMNT/ZZ_KZABE, '/')">
                                        <xsl:value-of select="tokenize(E1EDT20/E1EDL20[1]/ZSHPMNT/ZZ_KZABE, '/')[1]" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="E1EDT20/E1EDL20[1]/ZSHPMNT/ZZ_KZABE"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:variable name="VoyageNo">
                                <xsl:if test="contains(E1EDT20/E1EDL20[1]/ZSHPMNT/ZZ_KZABE, '/')">
                                    <xsl:value-of select="tokenize(E1EDT20/E1EDL20[1]/ZSHPMNT/ZZ_KZABE, '/')[2]" />
                                </xsl:if>
                            </xsl:variable>
                            
                            <ns0:VesselNo>
                                <xsl:value-of select="$VesselNo"/>
                            </ns0:VesselNo>
                            <ns0:VoyageNo>
                                <xsl:value-of select="$VoyageNo"/>
                            </ns0:VoyageNo>
                        </xsl:if>
                        
                        
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
                            <xsl:choose>
                                <xsl:when test="$OrderType = 'SEA'">
                                    <xsl:value-of select="E1EDT20/E1EDL20[1]/ZSHPMNT/ZZ_BKNO"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="E1EDT20/TKNUM"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ns0:BillofLadingNo>
                        
                        <xsl:if test="$OrderType = 'SEA'">
                            <ns0:GrossWeight>
                                <xsl:value-of select="format-number(sum(E1EDT20/E1EDL20/E1EDL24[LFIMG > 0][number(MATNR) != 36462]/BRGEW), '#.###')"/>
                            </ns0:GrossWeight>
                            <ns0:NettWeight>
                                <xsl:value-of select="format-number(sum(E1EDT20/E1EDL20/E1EDL24[LFIMG > 0][number(MATNR) != 36462]/NTGEW), '#.###')"/>
                            </ns0:NettWeight>
                            <ns0:Quantity>
                                <xsl:value-of select="format-number(sum(E1EDT20/E1EDL20/E1EDL24[LFIMG > 0]/LFIMG), '#.###')"/>
                            </ns0:Quantity>
                            <ns0:ContainerNo>
                                <xsl:if test="string-length($ContainerNo) &lt;= 13">
                                    <xsl:value-of select="$ContainerNo" />
                                </xsl:if>
                            </ns0:ContainerNo>
                            <ns0:ContainerSizeCode>
                                <xsl:value-of select="E1EDT20/E1EDL20[1]/ZSHPMNT/ZZEQ_TYPE"/>
                            </ns0:ContainerSizeCode>
                            <ns0:SealNo>
                                <xsl:variable name="SealNos">
                                    <xsl:value-of select="E1EDT20/E1TXTH6[TDID = 'ZSEA']/E1TXTP6/TDLINE" />
                                </xsl:variable>
                                <xsl:value-of select="substring(translate($SealNos, ' ', ''), 1, 30)"/>
                            </ns0:SealNo>
                        </xsl:if>
                        
                        <!-- Douane -->
                        
                        <ns0:IncotermCode>
                            <xsl:value-of select="E1EDT20/E1EDL20[1]/INCO1" />
                        </ns0:IncotermCode>
                        
                        <ns0:IncotermCity>
                            <xsl:value-of select="E1EDT20/E1EDL20[1]/INCO2" />
                        </ns0:IncotermCity>
                        
                        <ns0:SenderAddress>
                            <!-- <ns0:No>
                                 <xsl:value-of select="E1EDT20/E1EDL20[1]/E1ADRM1[PARTNER_Q = 'OSP']/PARTNER_ID"/>
                                 </ns0:No> -->
                            <ns0:Name>
                                <xsl:value-of select="substring(E1EDT20/E1EDL20[1]/E1ADRM1[PARTNER_Q = 'OSP']/NAME1, 1, 100)"/>
                            </ns0:Name>
                            <ns0:Address>
                                <xsl:value-of select="substring(E1EDT20/E1EDL20[1]/E1ADRM1[PARTNER_Q = 'OSP']/STREET1, 1, 100)"/>
                            </ns0:Address>
                            <ns0:City>
                                <xsl:value-of select="substring(E1EDT20/E1EDL20[1]/E1ADRM1[PARTNER_Q = 'OSP']/CITY1, 1, 30)"/>
                            </ns0:City>
                            <ns0:PostCode>
                                <xsl:value-of select="substring(E1EDT20/E1EDL20[1]/E1ADRM1[PARTNER_Q = 'OSP']/POSTL_COD1, 1, 20)"/>
                            </ns0:PostCode>
                            <ns0:CountryRegionCode>
                                <xsl:value-of select="substring(E1EDT20/E1EDL20[1]/E1ADRM1[PARTNER_Q = 'OSP']/COUNTRY1, 1, 10)"/>
                            </ns0:CountryRegionCode>
                            <ns0:Attribute10>
                                <xsl:value-of select="substring(E1EDT20/E1EDL20[1]/E1ADRM1[PARTNER_Q = 'OSP']/PARTNER_ID, 1, 30)"/>
                            </ns0:Attribute10>
                        </ns0:SenderAddress>
                        
                        <ns0:AgentAddress>
                            <ns0:Name>
                                <xsl:value-of select="substring(E1EDT20/E1EDL20[1]/E1ADRM1[PARTNER_Q = 'ZW']/NAME1, 1, 100)"/>
                            </ns0:Name>
                        </ns0:AgentAddress>
                        
                        <ns0:Attribute04>
                            <xsl:choose>
                                <xsl:when test="E1EDT20/E1EDL20[1]/E1EDL21/LFART = 'NLCC'">
                                    <xsl:text>109</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>101</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ns0:Attribute04>
                        
                        <xsl:if test="$OrderType = 'SEA'">
                            <ns0:Attribute03>
                                <xsl:value-of select="format-number(sum(E1EDT20/E1EDL20/E1EDL24[LFIMG > 0][number(MATNR) = 36462]/BRGEW), '#.###')"/>
                            </ns0:Attribute03>
                            <!-- <ns0:Attribute06>
                                 <xsl:value-of select="sum(E1EDT20/E1EDL20/E1EDL24[LFIMG > 0][number(MATNR) != 36462]/BRGEW) + sum(E1EDT20/E1EDL20/E1EDL24[LFIMG > 0][number(MATNR) = 36462]/BRGEW)"/>
                                 </ns0:Attribute06> -->
                            <ns0:Attribute06>
                                <xsl:value-of select="format-number(sum(E1EDT20/E1EDL20/E1EDL24[LFIMG > 0]/BRGEW), '#.###')"/>
                            </ns0:Attribute06>
                            <!-- <ns0:Attribute06>
                                 <xsl:value-of select="sum(E1EDT20/E1EDL20/BTGEW)"/>
                                 </ns0:Attribute06> -->
                         </xsl:if>
                        
                        <ns0:DocumentLines>
                            <xsl:for-each select="E1EDT20/E1EDL20/E1EDL24[LFIMG > 0][number(MATNR) != 36462][count(. | key('GroupedDocumentLines', concat(MATNR, '-', CHARG, '-', ../E1ADRM1[PARTNER_Q = 'WE']/PARTNER_ID, '-', VGBEL, '-', ../VBELN, '-', VRKME, '-', E1EDL35/HERKL, '-', VGPOS))[1]) = 1]">
                                <xsl:variable name="LineKey" select="concat(MATNR, '-', CHARG, '-', ../E1ADRM1[PARTNER_Q = 'WE']/PARTNER_ID, '-', VGBEL, '-', ../VBELN, '-', VRKME, '-', E1EDL35/HERKL, '-', VGPOS)" />
                                <xsl:if test="$LineKey != '-------'">
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
                                                <xsl:when test="(../E1ADRM1[PARTNER_Q = 'WE']/PARTNER_ID = 'X5622') and ($OrderType2 != 'TRUCK EU')">
                                                    <xsl:text>CLEARED</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="(../E1ADRM1[PARTNER_Q = 'WE']/PARTNER_ID = 'X5623')">
                                                    <xsl:text>CLEARED</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="../E1ADRM1[PARTNER_Q = 'WE']/PARTNER_ID = 'X5610'">
                                                    <xsl:text>BONDED</xsl:text>
                                                </xsl:when>
                                            </xsl:choose>
                                        </ns0:CustomsCode>
                                        
                                        <ns0:OrderQuantity>
                                            <xsl:value-of select="sum(key('GroupedDocumentLines', $LineKey)/LFIMG)" />
                                        </ns0:OrderQuantity>
                                        
                                        <ns0:OrderUnitofMeasureCode>
                                            <xsl:value-of select="VRKME" />
                                        </ns0:OrderUnitofMeasureCode>
                                        
                                        <ns0:GrossWeight>
                                            <xsl:value-of select="sum(key('GroupedDocumentLines', $LineKey)/BRGEW)" />
                                        </ns0:GrossWeight>
                                        
                                        <ns0:NetWeight>
                                            <xsl:value-of select="sum(key('GroupedDocumentLines', $LineKey)/NTGEW)" />
                                        </ns0:NetWeight>
                                        
                                        <ns0:CountryofOriginCode>
                                            <xsl:value-of select="E1EDL35/HERKL" />
                                        </ns0:CountryofOriginCode>
                                        
                                        <ns0:Attribute01>
                                            <xsl:value-of select="../VBELN" />
                                        </ns0:Attribute01>
                                        
                                        <ns0:Attribute06>
                                            <xsl:value-of select="VGBEL" />
                                        </ns0:Attribute06>
                                        
                                        <ns0:ExternalDocumentNo>
                                            <xsl:value-of select="format-number(../../TKNUM, '#')" />
                                        </ns0:ExternalDocumentNo>
                                        
                                        <!--DOC INFO SET  -->
                                        <ns0:Attributes>
                                            <!-- <ns0:Attribute>
                                                 <ns0:Code>
                                                 <xsl:text>LINENO</xsl:text>
                                                 </ns0:Code>
                                                 <ns0:Value>
                                                 <xsl:value-of select="POSNR" /> removed from message to allow for grouping
                                                 </ns0:Value>
                                                 </ns0:Attribute> -->
                                            <ns0:Attribute>
                                                <ns0:Code>
                                                    <xsl:text>POLINENO</xsl:text>
                                                </ns0:Code>
                                                <ns0:Value>
                                                    <xsl:value-of select="VGPOS" />
                                                </ns0:Value>
                                            </ns0:Attribute>
                                        </ns0:Attributes>
                                        
                                        <ns0:SenderAddress>
                                            <!-- <ns0:No>
                                                 <xsl:value-of select="../../E1EDT20/E1EDL20[1]/E1ADRM1[PARTNER_Q = 'OS0']/PARTNER_ID"/>
                                                 </ns0:No> -->
                                            <ns0:Name>
                                                <xsl:value-of select="substring(../E1ADRM1[PARTNER_Q = 'OSO']/NAME1, 1, 100)"/>
                                            </ns0:Name>
                                            <ns0:Address>
                                                <xsl:value-of select="substring(../E1ADRM1[PARTNER_Q = 'OSO']/STREET1, 1, 100)"/>
                                            </ns0:Address>
                                            <ns0:City>
                                                <xsl:value-of select="substring(../E1ADRM1[PARTNER_Q = 'OSO']/CITY1, 1, 30)"/>
                                            </ns0:City>
                                            <ns0:PostCode>
                                                <xsl:value-of select="substring(../E1ADRM1[PARTNER_Q = 'OSO']/POSTL_COD1, 1, 20)"/>
                                            </ns0:PostCode>
                                            <ns0:CountryRegionCode>
                                                <xsl:value-of select="substring(../E1ADRM1[PARTNER_Q = 'OSO']/COUNTRY1, 1, 10)"/>
                                            </ns0:CountryRegionCode>
                                            <ns0:Attribute10>
                                                <xsl:value-of select="substring(../E1ADRM1[PARTNER_Q = 'OSO']/PARTNER_ID, 1, 30)"/>
                                            </ns0:Attribute10>
                                        </ns0:SenderAddress>
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