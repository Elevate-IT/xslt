<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/stockstatus:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" 
                version="3.0">
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    
    <xsl:key name="Group-by-MATNO-QUAL" match="//s0:Carriers/s0:Carrier/s0:ContentLines/s0:CarrierContent" use="concat(s0:ExternalCustomerItemNo, '-', s0:Attribute01)" />
    
    <xsl:template match="/">
        <xsl:apply-templates select="//s0:Message/s0:Customers/s0:Customer"/>
    </xsl:template>
    
    <xsl:template match="//s0:Message/s0:Customers/s0:Customer">
        <!-- <ns0:EANCOM_D01B_INVRPT> -->
        <ns0:EFACT_D97A_INVRPT>
            <!-- <UNB></UNB> -->
            <UNH>
                <UNH1>
                    <xsl:value-of select="//s0:Header/s0:MessageID" />
                </UNH1>
                <UNH2>
                    <UNH2.1>INVRPT</UNH2.1>
                    <UNH2.2>D</UNH2.2>
                    <UNH2.3>97A</UNH2.3>
                    <UNH2.4>UN</UNH2.4>
                </UNH2>
            </UNH>
            <ns0:BGM>
                <ns0:C106>    
                    <C10601>               
                        <xsl:value-of select="//s0:Header/s0:MessageID" />
                    </C10601>               
                </ns0:C106>
            </ns0:BGM>
            <!-- <ns0:DTM>
                 <ns0:C507>
                 <C50701>137</C50701>
                 <C50702>
                 <xsl:value-of select="format-dateTime(//s0:Header/s0:CreationDateTime,'[Y0001][M01][D01]')" />
                 </C50702>
                 <C50703>102</C50703>
                 </ns0:C507>
                 </ns0:DTM> -->
            <ns0:DTM>
                <ns0:C507>
                    <C50701>366</C50701>
                    <C50702>
                        <xsl:value-of select="format-dateTime(current-dateTime(), '[Y][M,2][D,2][H,2][m,2]')"/>
                    </C50702>
                    <C50703>203</C50703>
                </ns0:C507>
            </ns0:DTM>
            <ns0:NADLoop1>
                <ns0:NAD>
                    <NAD01>GM</NAD01>
                    <ns0:C082>
                        <C08201>129</C08201>
                        <C08203>91</C08203>
                    </ns0:C082>
                </ns0:NAD>
                
                <ns0:LOC>
                    <LOC01>18</LOC01>
                    <ns0:C517>
                        <C51701>129</C51701>
                        <C51703>91</C51703>
                    </ns0:C517>
                </ns0:LOC>
            </ns0:NADLoop1>
            
            <xsl:for-each select="//s0:Carriers/s0:Carrier/s0:ContentLines/s0:CarrierContent[count(. | key('Group-by-MATNO-QUAL', concat(s0:ExternalCustomerItemNo, '-', s0:Attribute01))[1]) = 1]">
                <xsl:variable name="LineKey" select="concat(s0:ExternalCustomerItemNo, '-', s0:Attribute01)" />
                <xsl:if test="$LineKey != '-'">
                    
                    <!-- <xsl:choose>
                         <xsl:when test="(position()<=5)"> -->
                    
                    <ns0:LINLoop1>
                        <ns0:LIN>
                            <LIN01>
                                <xsl:value-of select="format-number(position(), '000000')"/>
                            </LIN01>
                            <ns0:C212>
                                <C21201>
                                    <xsl:value-of select="s0:ExternalCustomerItemNo" />
                                </C21201>
                                <C21204>90</C21204>
                            </ns0:C212>
                        </ns0:LIN>
                        <!-- <ns0:PIA>
                             <PIA01>5</PIA01>
                             <ns0:C212_2>
                             <C21201>
                             <xsl:value-of select="s0:ExternalCustomerItemNo" />
                             </C21201>
                             <C21202>SA</C21202>
                             </ns0:C212_2>
                             </ns0:PIA> -->
                        <ns0:INVLoop1>
                            <ns0:INV>
                                <INV04>
                                    <xsl:text>2</xsl:text>
                                </INV04> 
                            </ns0:INV>
                            
                            <ns0:QTY_2>
                                <ns0:C186_2>
                                    <C18601>145</C18601>
                                    <C18602>
                                        <xsl:value-of select="sum(key('Group-by-MATNO-QUAL', $LineKey)/s0:Quantity)" />
                                    </C18602>
                                    <C18603>PCE</C18603>
                                </ns0:C186_2>
                            </ns0:QTY_2>
                            
                            <!-- <ns0:GIN_2>
                                 <GIN01>BJ</GIN01>
                                 <ns0:C208_6>
                                 <C20801>
                                 <xsl:value-of select="../../s0:No" />
                                 </C20801>
                                 </ns0:C208_6>
                                 </ns0:GIN_2> -->
                            
                            <!-- <ns0:GIN_2>
                                 <GIN01>BX</GIN01>
                                 <ns0:C208_6>
                                 <C20801>
                                 <xsl:value-of select="s0:ExBatchNo" />
                                 </C20801>
                                 </ns0:C208_6>
                                 </ns0:GIN_2> -->
                            
                            <!-- <ns0:DTM_8>
                                 <ns0:C507_8>
                                 <C50701>361</C50701>
                                 <C50702>
                                 <xsl:value-of select="format-date(s0:ExpirationDate,'[Y0001][M01][D01]')" />
                                 </C50702>
                                 <C50703>102</C50703>
                                 </ns0:C507_8>
                                 </ns0:DTM_8> -->
                            
                            <ns0:RFFLoop4>
                                <ns0:RFF_4>
                                    <ns0:C506_4>
                                        <C50601>ZZR</C50601>
                                        <C50602>
                                            <xsl:variable name="QualIndicator" >
                                                <xsl:choose>
                                                    <xsl:when test="s0:Attribute01 = 'AVAILABLE'">1</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'AWAITING SCRAP'">AS01</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'BLOCKED'"></xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'DAMAGED'">DA01</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'DAMAGED CARTONS'">28</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'EXHIBITION STOCK'">40</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'FAULTY LOAN'">SA02</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'GRADED STOCK'">14</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'INSURANCE NO STOCK'">IN02</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'INSURANCE STOCK'">IN01</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'INVESTIGATE/RE-WORK'">TE01</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'JCI SOUTH AND EXPORT'">140S&amp;E</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'NON-ROHS'">15</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'OLD SPECS'">2</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'OLD STOCK'">14</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'OUT OF WARRANTY'">WA01</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'RESERVED STOCK'">XX01</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'RETURNS'">RE01</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'RE-WORK (HACE)'">TE02</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'ROHS: AVAILABLE'"></xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'SAMPLE STOCK'">SA01</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'SERVICE (HACE)'">TE03</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'SHORTAGE'">SK99</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'STOCK DISCREPANCY'">SK99</xsl:when>
                                                    <xsl:when test="s0:Attribute01 = 'SURPLUS'">SK99</xsl:when>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:choose>
                                                <xsl:when test="string-length($QualIndicator) = 0">
                                                    <xsl:text>0001</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="string-length($QualIndicator) &lt;= 4">
                                                    <xsl:value-of select="substring(concat('0000', $QualIndicator), (string-length($QualIndicator) + 1), (string-length($QualIndicator) + 4))"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$QualIndicator"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </C50602>
                                    </ns0:C506_4>
                                </ns0:RFF_4>  
                            </ns0:RFFLoop4>                
                        </ns0:INVLoop1>
                        
                        <!-- </ns0:INVLoop1>
                             <ns0:QTYLoop2>
                             <ns0:QTY_2>
                             <ns0:C186_2>
                             <C18601>145</C18601>
                             <C18602>
                             <xsl:value-of select="s0:Quantity" />
                             </C18602>
                             <C18603>
                             <xsl:value-of select="s0:UnitofMeasureCode" />
                             </C18603>
                             </ns0:C186_2>
                             </ns0:QTY_2>
                             <ns0:GIN_2>
                             <GIN01>BJ</GIN01>
                             <ns0:C208_6>
                             <C20801>
                             <xsl:value-of select="../../s0:No" />
                             </C20801>
                             </ns0:C208_6>
                             </ns0:GIN_2>
                             <ns0:GIN_2>
                             <GIN01>BX</GIN01>
                             <ns0:C208_6>
                             <C20801>
                             <xsl:value-of select="s0:ExBatchNo" />
                             </C20801>
                             </ns0:C208_6>
                             </ns0:GIN_2>
                             <ns0:DTM_8>
                             <ns0:C507_8>
                             <C50701>361</C50701>
                             <C50702>
                             <xsl:value-of select="format-date(s0:ExpirationDate,'[Y0001][M01][D01]')" />
                             </C50702>
                             <C50703>102</C50703>
                             </ns0:C507_8>
                             </ns0:DTM_8>
                             </ns0:QTYLoop2> -->
                     </ns0:LINLoop1>
                    <!-- </xsl:when>
                         </xsl:choose> -->
                 </xsl:if>
            </xsl:for-each>
        </ns0:EFACT_D97A_INVRPT>
        <!-- </ns0:EANCOM_D01B_INVRPT> -->
    </xsl:template>
</xsl:stylesheet>
