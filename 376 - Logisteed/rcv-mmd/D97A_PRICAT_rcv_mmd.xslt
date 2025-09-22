<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript"
                xmlns:ns0="www.boltrics.nl/materialmasterdata:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                version="3.0">
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    <xsl:template match="s0:EFACT_D97A_PRICAT">
        <ns0:Message>
            <ns0:Header>
                <ns0:MessageID>
                    <xsl:value-of select="UNH/UNH1" />
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
            </ns0:Header>
            
            <ns0:CustomerItems>
                <xsl:for-each select="s0:PGILoop1/s0:LINLoop1[s0:LIN/LIN01=1]">
                    <ns0:CustomerItem>
                        <ns0:ExternalNo>
                            <xsl:value-of select="s0:LIN/s0:C212/C21201"/>
                        </ns0:ExternalNo>
                        <ns0:Description>
                            <xsl:value-of select="s0:IMD/s0:C273/C27304"/>
                        </ns0:Description>
                        
                        <ns0:SearchDescription>
                            <xsl:value-of select="s0:IMD/s0:C273/C27304"/>
                        </ns0:SearchDescription>
                        
                        <ns0:TariffNo>
                            <xsl:value-of select="substring(//s0:FTX_3[s0:C108_3/C10801=999]/s0:C108_3/C10802, 1, 8)"/>
                        </ns0:TariffNo>
                        <ns0:TaricCode>
                            <xsl:value-of select="substring(//s0:FTX_3[s0:C108_3/C10801=999]/s0:C108_3/C10802, 9, 2)"/>
                        </ns0:TaricCode>
                        
                        <!-- <ns0:Status>
                            <xsl:text>1</xsl:text>
                        </ns0:Status> -->

                        <!-- <xsl:if test="s0:LOC/ns0:C108/C10804!=''">
                             <ns0:CountryofOriginCode>
                             <xsl:value-of select="s0:LOC/ns0:C108/C10804"/>
                             </ns0:CountryofOriginCode>
                             </xsl:if> -->
                        
                        <ns0:UnitOfMeasures> 
                            <ns0:UnitOfMeasure>                                   
                                <ns0:QtyperUnitofMeasure>
                                    <xsl:value-of select="//s0:LINLoop1/s0:QTY_4[s0:C186_4/C18601 = 52]/s0:C186_4/C18602" />
                                </ns0:QtyperUnitofMeasure>
                                <ns0:Code>
                                    <xsl:value-of select="//s0:LINLoop1/s0:QTY_4[s0:C186_4/C18601 = 52]/s0:C186_4/C18603" />
                                </ns0:Code>
                                
                                <!-- <ns0:EANCode>
                                     <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:LIN/s0:C212_6/C21201" />
                                     </ns0:EANCode> -->
                                
                                <ns0:GrossWeight>
                                    <xsl:value-of select="s0:MEA_2[s0:C502_2/C50201='AAB']/s0:C174_2/C17402" />
                                </ns0:GrossWeight> 
                                
                                <!-- <xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='AAA']/s0:C174_2/C17402!=''">
                                     <ns0:NetWeight>
                                     <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=2]/s0:MEA_2[s0:C502_3/C50201 ='AAA']/s0:C174_2/C17402" />
                                     </ns0:NetWeight>
                                     </xsl:if> -->
                                
                                <!-- <xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='AAB']/s0:C174_2/C17402!=''">
                                     <ns0:GrossWeight>
                                     <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='AAB']/s0:C174_2/C17402" />
                                     </ns0:GrossWeight>
                                     </xsl:if> -->
                                
                                
                                
                                <!-- <xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='HT']/s0:C174_2/C17402!=''">
                                     <ns0:Height>
                                     <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='HT']/s0:C174_2/C17402" />
                                     </ns0:Height>
                                     </xsl:if> -->
                                
                                <!-- <xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='DT']/s0:C174_2/C17402!=''">
                                     <ns0:Length>
                                     <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='DT']/s0:C174_2/C17402" />
                                     </ns0:Length>
                                     </xsl:if> -->
                                
                                <!-- <xsl:if test="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='WT']/s0:C174_2/C17402!=''">
                                     <ns0:Width>
                                     <xsl:value-of select="//s0:LINLoop1[s0:LIN/LIN01=1]/s0:MEA_2[s0:C502_3/C50201 ='WT']/s0:C174_2/C17402" />
                                     </ns0:Width>
                                     </xsl:if> -->
                                
                                <!-- <ns0:UnitOfMeasureCarriers>
                                    <ns0:UnitOfMeasureCarrier>
                                        
                                        <ns0:CarrierTypeCode>EURO</ns0:CarrierTypeCode>
                                        <ns0:QtyperUOMCode>
                                            <xsl:value-of select="//s0:LINLoop1[s0:QTYLoop1/s0:QTY_2/s0:C186_2/C18603 = 'TU']/s0:QTYLoop1/s0:QTY_2/s0:C186_2/C18602" />
                                        </ns0:QtyperUOMCode>
                                        
                                    </ns0:UnitOfMeasureCarrier>
                                </ns0:UnitOfMeasureCarriers> -->
                                
                            </ns0:UnitOfMeasure>
                        </ns0:UnitOfMeasures>
                    </ns0:CustomerItem>
                </xsl:for-each>
            </ns0:CustomerItems>
        </ns0:Message>
    </xsl:template>
</xsl:stylesheet>
