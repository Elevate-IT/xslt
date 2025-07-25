<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                exclude-result-prefixes="msxsl var s0"
                version="3.0"  > 
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    <xsl:template match="/">
        <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
    </xsl:template>
    <xsl:template match="//s0:Message/s0:Documents/s0:Document">
        <xsl:variable name="Counter" select="position()"></xsl:variable>
        <xsl:variable name="InBulk" select="s0:Attributes/s0:Attribute[s0:Code = 'ARDO_BULK']/s0:Value"/>
        <ns0:EFACT_D01B_DESADV>
            <UNH>
                <UNH1>
                    <xsl:value-of select="//s0:Header/s0:MessageID" />
                </UNH1>
                <UNH2>
                    <UNH2.1>DESADV</UNH2.1>
                    <UNH2.2>D</UNH2.2>
                    <UNH2.3>01B</UNH2.3>
                    <UNH2.4>UN</UNH2.4>
                    <UNH2.5>EAN007</UNH2.5>
                </UNH2>
            </UNH>
            
            <ns0:BGM>
                <ns0:C002>
                    <C00201>351</C00201>
                </ns0:C002>
                <ns0:C106>
                    <C10601> <xsl:value-of select="s0:No"/></C10601>
                </ns0:C106>
                <BGM03>9</BGM03>
            </ns0:BGM>
            
            <ns0:DTM>
                <ns0:C507>
                    <C50701>137</C50701>
                    <C50702>
                        <xsl:value-of select="format-date(s0:DocumentDate,'[Y0001][M01][D01]')" />
                    </C50702>
                    <C50703>102</C50703>
                </ns0:C507>
            </ns0:DTM>
            <ns0:DTM>
                <ns0:C507>
                    <C50701>11</C50701>
                    <C50702>
                        <xsl:value-of select="format-date(s0:PostingDate, '[Y0001][M01][D01]')" />
                    </C50702>
                    <C50703>102</C50703>
                </ns0:C507>
            </ns0:DTM>
            
            <ns0:RFFLoop1>
                <ns0:RFF>
                    <ns0:C506>
                        <C50601>VN</C50601>
                        <C50602>
                            <xsl:value-of select="s0:ExternalDocumentNo"/>
                        </C50602>
                    </ns0:C506>
                </ns0:RFF>
            </ns0:RFFLoop1>
            
            <!-- <ns0:RFFLoop1>
                 <ns0:RFF>
                 <ns0:C506>
                 <C50601>DQ</C50601>
                 <C50602>
                 <xsl:value-of select="s0:ExternalReference"/>
                 </C50602>
                 </ns0:C506>
                 </ns0:RFF>
                 </ns0:RFFLoop1> -->
            
            <!-- <ns0:RFFLoop1>
                 <ns0:RFF>
                 <ns0:C506>
                 <C50601>VM</C50601>
                 <C50602>
                 Your so/to/po order nr ERP
                 </C50602>
                 </ns0:C506>
                 </ns0:RFF>
                 </ns0:RFFLoop1>			 -->
            <!-- <ns0:RFFLoop1>
                 <ns0:RFF>
                 <ns0:C506>
                 <C50601>ZZZ</C50601>
                 <C50602>
                 
                 </C50602>
                 </ns0:C506>
                 </ns0:RFF>
                 </ns0:RFFLoop1> -->
            
            <!-- Party info Supplier -->
            <ns0:NADLoop1>
                <ns0:NAD>
                    <NAD01>SU</NAD01>
                    <ns0:C082>
                        <C08201>
                            <xsl:value-of select="upper-case(//s0:ToTradingPartner)" />
                        </C08201>
                        <C08202>9</C08202>
                    </ns0:C082>
                    <ns0:C080>
                        <C08001>
                            <!-- supplier name Customer-->
                            <xsl:value-of select="upper-case(s0:Customer/s0:Name)"/>
                        </C08001>
                    </ns0:C080>
                    <ns0:C059>
                        <C05901>
                            <!-- StreetCustomer -->
                            <xsl:value-of select="upper-case(s0:Customer/s0:Address)"/>
                        </C05901>
                        <C05902>
                            <!-- city Customer-->
                            <xsl:value-of select="upper-case(s0:Customer/s0:City)"/>
                        </C05902>
                        <C05903>
                            <!-- Postal  Customer-->
                            <xsl:value-of select="upper-case(s0:Customer/s0:PostCode)"/>
                        </C05903>
                        <C05904>
                            <!-- Country Customer-->
                            <xsl:value-of select="upper-case(s0:Customer/s0:CountryRegionCode)"/>
                        </C05904>
                    </ns0:C059>
                </ns0:NAD>
            </ns0:NADLoop1>
            
            <!-- Party info Ship from -->
            <ns0:NADLoop1>
                <ns0:NAD>
                    <NAD01>SF</NAD01>
                    <ns0:C082>
                        <C08201>
                            <!-- <xsl:value-of select="s0:SenderAddress/s0:EANCode" /> -->
                            <!-- Depot GLN code ? -->
                            <xsl:text>5430002021003</xsl:text>
                        </C08201>
                    </ns0:C082>
                    <ns0:C080>
                        <C08001>
                            <!-- <xsl:value-of select="upper-case(s0:SenderAddress/s0:Name)" /> -->
                            <xsl:text>ZEEBRUGGE FOOD LOGISTICS NV</xsl:text>
                        </C08001>
                    </ns0:C080>
                    <ns0:C059>
                        <C05901>
                            <!-- <xsl:value-of select="upper-case(s0:SenderAddress/s0:Address)" /> -->
                            <xsl:text>IERSE ZEESTRAAT 50</xsl:text>
                        </C05901>
                        <C05902>
                            <!-- <xsl:value-of select="upper-case(s0:SenderAddress/s0:City)" /> -->
                            <xsl:text>ZEEBRUGGE</xsl:text>
                        </C05902>
                        <C05903>
                            <!-- <xsl:value-of select="upper-case(s0:SenderAddress/s0:PostCode)" /> -->
                            <xsl:text>8380</xsl:text>
                        </C05903>
                        <C05904>
                            <!-- <xsl:value-of select="upper-case(s0:SenderAddress/s0:CountryName)" /> -->
                            <xsl:text>BE</xsl:text>
                        </C05904>
                    </ns0:C059>
                </ns0:NAD>
            </ns0:NADLoop1>
            
            <!-- Party info DP -->
            <ns0:NADLoop1>
                <ns0:NAD>
                    <NAD01>DP</NAD01>
                    <ns0:C082>
                        <C08201>
                            <xsl:value-of select="upper-case(s0:ShipToAddress/s0:ExternalNo)" />
                        </C08201>
                        <C08202>9</C08202>
                    </ns0:C082>
                    <ns0:C080>
                        <C08001>
                            <xsl:value-of select="upper-case(s0:ShipToAddress/s0:Name)" />
                        </C08001>
                    </ns0:C080>
                    <ns0:C059>
                        <C05901>
                            <xsl:value-of select="upper-case(s0:ShipToAddress/s0:Address)" />
                        </C05901>
                        <C05902>
                            <xsl:value-of select="upper-case(s0:ShipToAddress/s0:City)" />
                        </C05902>
                        <C05903>
                            <xsl:value-of select="upper-case(s0:ShipToAddress/s0:PostCode)" />
                        </C05903>
                        <C05904>
                            <xsl:value-of select="upper-case(s0:ShipToAddress/s0:CountryRegionCode)" />
                        </C05904>
                    </ns0:C059>
                </ns0:NAD>
            </ns0:NADLoop1>
            
            <!-- <ns0:TDTLoop1>
                 <TDT>
                 <ns0:TDT01>20</ns0:TDT01>
                 <ns0:C040>
                 <ns0:C04001>
                 carrier gln/code
                 </ns0:C04001>
                 <ns0:C04002>ZZ</ns0:C04002>
                 <ns0:C04003></ns0:C04003>
                 <ns0:C04004>
                 Carrier name
                 </ns0:C04004>
                 </ns0:C040>
                 </TDT>
                 </ns0:TDTLoop1> -->
            
            <ns0:CPSLoop1>
                <ns0:CPS>
                    <CPS01>1</CPS01>
                </ns0:CPS>
                <ns0:PACLoop1>
                    <ns0:PAC>
                        <PAC01>
                            <xsl:value-of select="s0:CarrierQuantity"/>
                        </PAC01>
                    </ns0:PAC>
                </ns0:PACLoop1>
            </ns0:CPSLoop1>
            
            <xsl:for-each select="//s0:Carriers/s0:Carrier/s0:Contents/s0:Content">
                <!-- <xsl:variable name="CarrierNo" select="()" /> -->
                <xsl:variable name="CarrierNo" select="s0:No" />
                <xsl:variable name="LineNo">
                    <xsl:value-of select="s0:DocumentLineNo" />
                </xsl:variable>
                <xsl:variable name="AttachedtoLineNo">
                    <xsl:value-of select="//s0:DocumentLine[s0:LineNo = $LineNo]/AttachedtoLineNo" />
                </xsl:variable>
                <ns0:CPSLoop1>
                    <ns0:CPS>
                        <CPS01>
                            <xsl:text>2</xsl:text>
                        </CPS01>
                        <CPS02>
                            <xsl:value-of select="position()"/>
                        </CPS02>
                    </ns0:CPS>
                    <ns0:PACLoop1>
                        <ns0:PAC>
                            <PAC01>1</PAC01>
                            <ns0:C202>
                                <C20201>
                                    <xsl:value-of select="s0:CarrierTypeCode"/>
                                </C20201>
                            </ns0:C202>
                        </ns0:PAC>
                        <ns0:PCILoop1>
                            <ns0:PCI>
                                <PCI01>33E</PCI01>
                            </ns0:PCI>
                            <ns0:GINLoop1>
                                <ns0:GIN>
                                    <GIN01>BJ</GIN01>
                                    <ns0:C208_2>
                                        <C20801>
                                            <xsl:value-of select="../../s0:No"/>
                                        </C20801>
                                    </ns0:C208_2>
                                </ns0:GIN>
                            </ns0:GINLoop1>
                        </ns0:PCILoop1>
                    </ns0:PACLoop1>
                    <ns0:LINLoop1>
                        <ns0:LIN>
                            <LIN01>
                                <xsl:value-of select="position()"/>
                            </LIN01>
                            <ns0:C212>
                                <C21201>
                                    <!-- Item no GTIN EANCodeBaseUnitofMeasure-->
                                    <xsl:value-of select="s0:EANCodeBaseUnitofMeasure"/>
                                </C21201>
                                <C21202>EN</C21202>
                            </ns0:C212>
                        </ns0:LIN>
                        <ns0:PIA>
                            <PIA01>5</PIA01>
                            <ns0:C212_2>
                                <C21201>
                                    <!-- your erp art no -->
                                    <xsl:value-of select="s0:ExternalNo"/>
                                </C21201>
                                <C21202>SA</C21202>
                            </ns0:C212_2>
                        </ns0:PIA>
                        <ns0:PIA>
                            <PIA01>1</PIA01>
                            <ns0:C212_2>
                                <C21201>
                                    <xsl:variable name="ERPLineNo">
                                        <xsl:choose>
                                            <xsl:when test="$AttachedtoLineNo != ''">
                                                <xsl:value-of select="//s0:DocumentLine[s0:LineNo = $AttachedtoLineNo]/s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="//s0:DocumentLine[s0:LineNo = $LineNo]/s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    
                                    <xsl:choose>
                                        <xsl:when test="$ERPLineNo != ''">
                                            <xsl:value-of select="$ERPLineNo"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="format-number($LineNo div 1000, '000000')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>                                    
                                    <!-- erp order line item no -->
                                    
                                </C21201>
                                <C21202>LI</C21202>
                            </ns0:C212_2>
                        </ns0:PIA>
                        
                        <!-- <ns0:QTY_3>
                             <ns0:C186_3>
                             <C18601>12</C18601>
                             <C18602>
                             <xsl:value-of select="s0:Quantity"/>        
                             </C18602>
                             <C18603>                                  
                             <xsl:if test="s0:UnitofMeasureCode = 'CRT'">
                             <xsl:text>TU</xsl:text>
                             </xsl:if>
                             </C18603>
                             </ns0:C186_3>
                             </ns0:QTY_3> -->
                        
                        <xsl:choose>
                            <xsl:when test="$InBulk = 'true'">
                                <!-- Bulk orders -->
                                <ns0:QTY_3>
                                    <ns0:C186_3>
                                        <C18601>12</C18601>
                                        <C18602>
                                            <xsl:value-of select="s0:NetWeight" />
                                        </C18602>
                                        <C18603>
                                            <xsl:text>KGM</xsl:text>
                                        </C18603>
                                    </ns0:C186_3>
                                </ns0:QTY_3>
                                
                                <ns0:QTY_3>
                                    <ns0:C186_3>
                                        <C18601>17E</C18601>
                                        <C18602>
                                            <xsl:value-of select="sum(s0:Quantity)" />
                                        </C18602>
                                        <C18603>
                                            <xsl:text>PAL</xsl:text>
                                        </C18603>
                                    </ns0:C186_3>
                                </ns0:QTY_3>
                                
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Per TU -->
                                <ns0:QTY_3>
                                    <ns0:C186_3>
                                        <C18601>12</C18601>
                                        <C18602>
                                            <xsl:value-of select="sum(s0:Quantity)" />
                                        </C18602>
                                        <C18603>
                                            <xsl:choose>
                                                <xsl:when test="substring(s0:UnitofMeasureCode, 1, 3) = 'CRT'">
                                                    <xsl:text>TU</xsl:text>
                                                </xsl:when>
                                            </xsl:choose>
                                        </C18603>
                                    </ns0:C186_3>
                                </ns0:QTY_3>
                                
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        <ns0:GIN_2>
                            <GIN01>AW</GIN01>
                            <C208_7>
                                <C20801>
                                    <!-- Original pallet picked from -->
                                    <xsl:value-of select="s0:CarrierNo"/>
                                </C20801>
                            </C208_7>
                        </ns0:GIN_2>
                        
                        <!-- empty if stock is free -->
                        <ns0:DLM_2>
                            <DLM01>N</DLM01>
                            <C522_2>
                                <C52201>1</C52201>
                                <C52202></C52202>
                                <C52203></C52203>
                                <C52204></C52204>
                                <C52205>
                                    <!-- BLK or FRE -->
                                    <!-- na te vragen -->
                                </C52205>
                            </C522_2>
                        </ns0:DLM_2>
                        <!-- close empty if stock is free -->
                        
                        <ns0:LOCLoop2>
                            <ns0:LOC_4>
                                <LOC01>1</LOC01>
                                <C519_4>
                                    <C51901>
                                        <xsl:value-of select="../../s0:BuildingCode"/>
                                    </C51901>
                                    <C51902>91</C51902>
                                </C519_4>
                                <C553_4>
                                    <C55301>
                                        <xsl:value-of select="../../s0:LocationNo"/>
                                    </C55301>
                                    <ns0:C55302>91</ns0:C55302>
                                </C553_4>
                            </ns0:LOC_4>
                        </ns0:LOCLoop2>
                        
                        <xsl:if test="s0:ExpirationDate != ''">
                            <ns0:PCILoop2>
                                <PCI_2>
                                    <PCI01>39E</PCI01>
                                </PCI_2>
                                <ns0:DTM_10>
                                    <ns0:C507_10>
                                        <C50701>361</C50701>
                                        <C50702>
                                            <xsl:value-of select="format-date(s0:ExpirationDate, '[Y0001][M01][D01]')"/>
                                        </C50702>
                                        <C50703>102</C50703>
                                    </ns0:C507_10>
                                </ns0:DTM_10>
                            </ns0:PCILoop2>
                        </xsl:if>
                        
                        <xsl:if test="s0:BatchNo != ''">
                            
                            <ns0:PCILoop2>
                                <ns0:PCI_2>
                                    <ns0:PCI01>36E</ns0:PCI01>
                                </ns0:PCI_2>
                                <ns0:GINLoop2>
                                    <ns0:GIN_3>
                                        <ns0:GIN01>BX</ns0:GIN01>
                                        <ns0:C208_12>
                                            <ns0:C20801>
                                                <xsl:value-of select="s0:ExternalBatchNo"/>
                                            </ns0:C20801>
                                        </ns0:C208_12>
                                    </ns0:GIN_3>
                                </ns0:GINLoop2>
                            </ns0:PCILoop2>
                        </xsl:if>
                    </ns0:LINLoop1>
                </ns0:CPSLoop1>
            </xsl:for-each>
        </ns0:EFACT_D01B_DESADV>
    </xsl:template>
</xsl:stylesheet>
