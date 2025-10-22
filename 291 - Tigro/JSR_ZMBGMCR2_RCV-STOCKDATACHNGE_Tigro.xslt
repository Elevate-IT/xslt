<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/stockdatachange:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:eit="http://www.elevate-it.be"
                exclude-result-prefixes = "#all" >   
    
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:function name="eit:createDate">
        <xsl:param name="idocDate"/>
        <xsl:value-of select="xs:date(concat(substring($idocDate, 1, 4), '-', substring($idocDate, 5, 2), '-', substring($idocDate, 7, 2)))" />
    </xsl:function>
    
    <xsl:function name="eit:createTime">
        <xsl:param name="idocTime"/>
        <xsl:value-of select="xs:time(concat(substring($idocTime, 1, 2), ':', substring($idocTime, 3, 2), ':', substring($idocTime, 5, 2)))" />
    </xsl:function>
    
    <xsl:template match="/">
        <xsl:apply-templates select="ZMBGMCR2/IDOC"/>
    </xsl:template>
    
    <xsl:template match="ZMBGMCR2/IDOC">
        <ns0:Message>
            <ns0:Header>
                <ns0:MessageID>
                    <xsl:value-of select="EDI_DC40/DOCNUM" />
                </ns0:MessageID>
                <ns0:CreationDateTime>
                    <xsl:value-of select="dateTime(eit:createDate(EDI_DC40/CREDAT), eit:createTime(EDI_DC40/CRETIM))"/>
                </ns0:CreationDateTime>
                <ns0:ProcesAction>
                    <xsl:text>INSERT</xsl:text>
                </ns0:ProcesAction>
                <ns0:FromTradingPartner>
                    <xsl:text>JSR</xsl:text>
                </ns0:FromTradingPartner>
                <ns0:ToTradingPartner>
                    <xsl:text>Tigro</xsl:text>
                </ns0:ToTradingPartner>
            </ns0:Header>
            
            <ns0:StockChanges>
                <xsl:for-each select="E1BP2017_GM_HEAD_01">
                    <ns0:StockChange>
                        <ns0:PostingDate>
                            <xsl:value-of select="eit:createDate(PSTNG_DATE)"/>
                        </ns0:PostingDate>

                        <ns0:DocumentNo>
                            <xsl:value-of select="ZZ1MGMCR/ZZMAT_DOC_NO"/>
                        </ns0:DocumentNo>
                        
                        <ns0:ExternalNo>
                            <xsl:value-of select="../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'H']/MATERIAL"/>
                        </ns0:ExternalNo>
                        
                        <ns0:ExternalBatchNo>
                            <xsl:value-of select="../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'H']/BATCH"/>
                        </ns0:ExternalBatchNo>
                        
                        <!-- <ns0:Quantity>
                            <xsl:value-of select="normalize-space(../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'H']/ENTRY_QNT)"/>
                        </ns0:Quantity>
                        
                        <ns0:UnitOfMeasureCode>
                            <xsl:value-of select="../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'H']/ENTRY_UOM"/>
                        </ns0:UnitOfMeasureCode> -->
                        
                        <ns0:NewBatchStatus>
                            <xsl:choose>
                                <xsl:when test="../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'S']/MOVE_TYPE = '321'">
                                    <xsl:text>20-VRIJ</xsl:text>
                                </xsl:when>
                                <xsl:when test="../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'S']/MOVE_TYPE = '322'">
                                    <xsl:text>50-KWALITEIT</xsl:text>
                                </xsl:when>
                                <xsl:when test="../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'S']/MOVE_TYPE = '343'">
                                    <xsl:text>20-VRIJ</xsl:text>
                                </xsl:when>
                                <xsl:when test="../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'S']/MOVE_TYPE = '344'">
                                    <xsl:text>60-VRAAG KLANT</xsl:text>
                                </xsl:when>
                                <xsl:when test="../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'S']/MOVE_TYPE = '349'">
                                    <xsl:text>50-KWALITEIT</xsl:text>
                                </xsl:when>
                                <xsl:when test="../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'S']/MOVE_TYPE = '350'">
                                    <xsl:text>60-VRAAG KLANT</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'S']/MOVE_TYPE"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ns0:NewBatchStatus>
                        
                        <ns0:ReasonCode>
                            <!-- <xsl:value-of select="../E1BP2017_GM_ITEM_CREATE[MVT_IND = 'H']/MOVE_REAS"/> -->
                        </ns0:ReasonCode>
                    </ns0:StockChange>
                </xsl:for-each>  
            </ns0:StockChanges>
        </ns0:Message>
    </xsl:template>
</xsl:stylesheet>