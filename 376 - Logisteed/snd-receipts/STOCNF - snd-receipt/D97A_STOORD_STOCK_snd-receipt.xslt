<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                exclude-result-prefixes="msxsl var s0"
                version="3.0"  > 
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    <xsl:template match="/">
        <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
    </xsl:template>
    <xsl:template match="//s0:Message/s0:Documents/s0:Document">
        <xsl:variable name="Counter" select="position()"></xsl:variable>
        <ns0:EFACT_D97A_DESADV>
            <UNH>
                <UNH1>
                    <xsl:value-of select="//s0:Header/s0:MessageID" />
                </UNH1>
                <UNH2>
                    <UNH2.1>DESADV</UNH2.1>
                    <UNH2.2>D</UNH2.2>
                    <UNH2.3>97A</UNH2.3>
                    <UNH2.4>UN</UNH2.4>
                    <UNH2.5>EDDS05</UNH2.5>
                </UNH2>
                <UNH4>
                    <UNH4.1>1</UNH4.1>
                </UNH4>
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
                        <C50601>SRN</C50601>
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
                    <NAD01>CN</NAD01> <!-- was SU -->
                    <ns0:C082>
                        <C08201>
                            <xsl:value-of select="upper-case(//s0:ToTradingPartner)" />
                        </C08201>
                        <C08202>9</C08202>
                    </ns0:C082>
                    <!-- <ns0:C080>
                         <C08001>
                         
                         <xsl:value-of select="upper-case(s0:Customer/s0:Name)"/>
                         </C08001>
                         </ns0:C080>
                         <ns0:C059>
                         <C05901>
                         
                         <xsl:value-of select="upper-case(s0:Customer/s0:Address)"/>
                         </C05901>
                         <C05902>
                         
                         <xsl:value-of select="upper-case(s0:Customer/s0:City)"/>
                         </C05902>
                         <C05903>
                         
                         <xsl:value-of select="upper-case(s0:Customer/s0:PostCode)"/>
                         </C05903>
                         <C05904>
                         
                         <xsl:value-of select="upper-case(s0:Customer/s0:CountryRegionCode)"/>
                         </C05904>
                         </ns0:C059> -->
                 </ns0:NAD>
            </ns0:NADLoop1>
            
            
            <!-- Party info DP -->
            <ns0:NADLoop1>
                <ns0:NAD>
                    <NAD01>CZ</NAD01>
                    <ns0:C082>
                        <C08201>
                            <xsl:value-of select="upper-case(s0:ShipToAddress/s0:ExternalNo)" />
                        </C08201>
                        <C08202>9</C08202>
                    </ns0:C082>
                    <!-- <ns0:C080>
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
                         </ns0:C059> -->
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
            
            <!-- <ns0:CPSLoop1>
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
                 </ns0:CPSLoop1> -->
            <ns0:CPSLoop1>
                <ns0:CPS>
                    <CPS01>
                        <xsl:text>1</xsl:text>
                    </CPS01>   
                </ns0:CPS>
                <xsl:for-each select="//s0:Carriers/s0:Carrier/s0:Contents/s0:Content">
                    
                    <!-- <CPS02>
                         <xsl:value-of select="position()"/>
                         </CPS02> -->
                    
                    <!-- <ns0:PACLoop1>
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
                         </ns0:PACLoop1> -->
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
                                <C21202>MF</C21202>
                                <C21203>92</C21203>
                            </ns0:C212>
                        </ns0:LIN>
                        
                        <ns0:PIA>
                            <PIA01><xsl:value-of select="position()"/></PIA01>
                            <ns0:C212_2>
                                <C21201>
                                    <!-- your erp art no -->
                                    <xsl:value-of select="s0:ExternalNo"/>
                                </C21201>
                                <C21202>ZZZ</C21202>
                            </ns0:C212_2>
                        </ns0:PIA>
                        <!-- <ns0:PIA>
                             <PIA01>1</PIA01>
                             <ns0:C212_2>
                             <C21201>                                  
                             <xsl:value-of select="//s0:DocumentLine[s0:LineNo = $LineNo]/s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value" />
                             </C21201>
                             <C21202>LI</C21202>
                             </ns0:C212_2>
                             </ns0:PIA> -->
                        
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
                        
                        <ns0:QTY_2>
                            <ns0:C186_2>
                                <C18601>12</C18601>
                                <C18602>
                                    <xsl:value-of select="sum(s0:Quantity)" />
                                </C18602>
                                <C18603>
                                    <xsl:text>PCE</xsl:text>
                                </C18603>
                            </ns0:C186_2>
                        </ns0:QTY_2>
                        
                        <ns0:GIN_2>
                            <ns0:GIN01>
                                <xsl:text>BN</xsl:text>
                            </ns0:GIN01>
                            <ns0:C208_6>
                                <C20801>
                                    <xsl:value-of select="s0:BatchNo" />
                                </C20801>
                            </ns0:C208_6>
                        </ns0:GIN_2>
                    </ns0:LINLoop1>
                </xsl:for-each>
            </ns0:CPSLoop1>
        </ns0:EFACT_D97A_DESADV>
    </xsl:template>
</xsl:stylesheet>
