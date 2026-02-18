<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes = "#all" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:template match="//ns0:Message">
        <ZMBGMCR01>
            <IDOC BEGIN="1">
                <xsl:apply-templates select="ns0:Header"/>
                
                <xsl:for-each-group select="ns0:Documents/ns0:Document" group-by="ns0:DocumentLines/ns0:DocumentLine/ns0:DocumentDetailLines/ns0:DocumentDetailLine/ns0:Attributes/ns0:Attribute[ns0:Code = 'DELIVERYNO']/ns0:Value">
                    <xsl:if test="current-grouping-key() != ''">
                        <xsl:apply-templates select=".">
                            <xsl:with-param name="REF_DOC_NO" select="current-grouping-key()"/>
                        </xsl:apply-templates>
                    </xsl:if>
                </xsl:for-each-group>
            </IDOC>
        </ZMBGMCR01>
    </xsl:template>
    
    <xsl:template match="ns0:Header">
        <EDI_DC40 SEGMENT="1">
            <MANDT>020</MANDT>
            <DOCNUM>
                <xsl:value-of select="concat(format-dateTime(ns0:CreationDateTime, '[Y0001][M01][D01][H01][m01][s01]'), substring(ns0:MessageID, string-length(ns0:MessageID) - 1))"/>
            </DOCNUM>
            <DOCREL>740</DOCREL>
            <STATUS>30</STATUS>
            <DIRECT>2</DIRECT>
            <IDOCTYP>ZMBGMCR01</IDOCTYP>
            <MESTYP>ZMBGMCR</MESTYP>
            <SNDPOR>HARGO</SNDPOR>
            <SNDPRT>LS</SNDPRT>
            <SNDPRN>HARGO</SNDPRN>
            <RCVPOR>SAPGPR</RCVPOR>
            <RCVPRT>LS</RCVPRT>
            <RCVPFC>LS</RCVPFC>
            <RCVPRN>SAPGPR</RCVPRN>
            <CREDAT>
                <xsl:value-of select="format-dateTime(ns0:CreationDateTime, '[Y0001][M01][D01]')"/>
            </CREDAT>
            <CRETIM>
                <xsl:value-of select="format-dateTime(ns0:CreationDateTime, '[H01][m01][s01]')"/>
            </CRETIM>
            <SERIAL>
                <xsl:value-of select="concat(format-dateTime(ns0:CreationDateTime, '[Y0001][M01][D01][H01][m01][s01]'), substring(ns0:MessageID, string-length(ns0:MessageID) - 1))"/>
            </SERIAL>
        </EDI_DC40>
    </xsl:template>
    
    <xsl:template match="ns0:Document">
        <xsl:param name="REF_DOC_NO"/>
        
        <Z1ZMBGMCR SEGMENT="1">
            <E1BP2017_GM_HEAD_01 SEGMENT="1">
                <PSTNG_DATE>
                    <xsl:value-of select="format-date(ns0:PostingDate, '[Y0001][M01][D01]')"/>
                </PSTNG_DATE>
                <DOC_DATE>
                    <xsl:value-of select="format-date(ns0:DocumentDate, '[Y0001][M01][D01]')"/>
                </DOC_DATE>
                <REF_DOC_NO>
                    <xsl:value-of select="substring(concat('0000000000000000', $REF_DOC_NO), string-length($REF_DOC_NO) + 1, 16)"/>
                </REF_DOC_NO>
                <PR_UNAME>INTERFAC</PR_UNAME>
            </E1BP2017_GM_HEAD_01>
            <E1BP2017_GM_CODE SEGMENT="1">
                <GM_CODE>01</GM_CODE> <!-- Monday 171: E1BP2017_GM_CODE/GM_CODE -> 01 gebruiken -->
            </E1BP2017_GM_CODE>
            
            <xsl:for-each select="ns0:DocumentLines/ns0:DocumentLine[ns0:Type = '1'][ns0:DocumentDetailLines/ns0:DocumentDetailLine/ns0:Attributes/ns0:Attribute[ns0:Code = 'DELIVERYNO']/ns0:Value = $REF_DOC_NO]">
                <xsl:variable name="OrigLine" as="xs:boolean">
                    <xsl:value-of select="count(ns0:AttachedtoLineNo) = 0"/>
                </xsl:variable>
                <xsl:variable name="LineNo">
                    <xsl:choose>
                        <xsl:when test="count(ns0:AttachedtoLineNo) = 0">
                            <xsl:value-of select="ns0:LineNo"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="ns0:AttachedtoLineNo"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:if test="$OrigLine and (number(ns0:PostedOrderQuantity) = 0) and (count(../ns0:DocumentLine[ns0:Type = '1'][ns0:AttachedtoLineNo = $LineNo]) = 0)">
                    <!-- Original lines with no postings on other - related - lines -->
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="OrigLine" select="../ns0:DocumentLine[ns0:LineNo = $LineNo]"/>
                        <xsl:with-param name="DocHeader" select="../../."/>
                    </xsl:apply-templates>
                </xsl:if>
                
                <xsl:if test="number(ns0:PostedOrderQuantity) &gt; 0">
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="OrigLine" select="../ns0:DocumentLine[ns0:LineNo = $LineNo]"/>
                        <xsl:with-param name="DocHeader" select="../../."/>
                    </xsl:apply-templates>
                </xsl:if>
                
            </xsl:for-each>
        </Z1ZMBGMCR>
    </xsl:template>
    
    <xsl:template match="ns0:DocumentLine">
        <xsl:param name="OrigLine"/>
        <xsl:param name="DocHeader"/>
        
        <xsl:variable name="split_info">
            <xsl:choose>
                <xsl:when test="$OrigLine/ns0:Attributes/ns0:Attribute[ns0:Code = 'SPLIT_INFO']/ns0:Value != ''">
                    <xsl:value-of select="$OrigLine/ns0:Attributes/ns0:Attribute[ns0:Code = 'SPLIT_INFO']/ns0:Value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>fillerdata</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:call-template name="loop">
            <xsl:with-param name="i" select="number(1)"/>
            <xsl:with-param name="max" select="count(tokenize($split_info, ';'))"/>
            <xsl:with-param name="DocHeader" select="$DocHeader"/>
            <xsl:with-param name="DocLine" select="current()"/>
            <xsl:with-param name="OrigLine" select="$OrigLine"/>
            <xsl:with-param name="splitInfo" select="$split_info"/>
            <xsl:with-param name="usedQty" select="number(0)"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="loop">
        <xsl:param name="i"/>
        <xsl:param name="max"/>
        <xsl:param name="DocHeader"/>
        <xsl:param name="DocLine"/>
        <xsl:param name="OrigLine"/>
        <xsl:param name="splitInfo"/>
        <xsl:param name="usedQty" as="xs:double"/>
        
        <xsl:if test="$i &lt;= $max">
            <xsl:variable name="split_info_part" select="tokenize($splitInfo, ';')[$i]" />
            
            <xsl:variable name="lastIteration" as="xs:boolean">
                <xsl:value-of select="$split_info_part = tokenize($splitInfo, ';')[count(tokenize($splitInfo, ';'))]"/>
            </xsl:variable>
            
            <xsl:variable name="customerQty" as="xs:double" select="number(tokenize($split_info_part, '/')[2])" />
            
            <xsl:variable name="qty" as="xs:double">
                <xsl:choose>
                    <xsl:when test="($DocLine/ns0:PostedOrderQuantity - $usedQty) &gt;= $customerQty and not($lastIteration)">
                        <xsl:choose>
                            <xsl:when test="$lastIteration">
                                <xsl:value-of select="$DocLine/ns0:PostedOrderQuantity - $usedQty"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$customerQty"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$DocLine/ns0:PostedOrderQuantity - $usedQty"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <E1BP2017_GM_ITEM_CREATE SEGMENT="1">
                <MATERIAL>
                    <xsl:value-of select="substring(concat('000000000000000000', $DocLine/ns0:ExternalNo), string-length($DocLine/ns0:ExternalNo) + 1, 18)"/>
                </MATERIAL>
                <PLANT>5622</PLANT>
                <STGE_LOC>A100</STGE_LOC>
                <BATCH>
                    <xsl:value-of select="$DocLine/ns0:ExternalBatchNo"/>
                </BATCH>
                <MOVE_TYPE>
                    <xsl:choose>
                        <xsl:when test="substring($DocHeader/ns0:Attribute04, 1, 3) = ('101', '109')">
                            <xsl:value-of select="substring($DocHeader/ns0:Attribute04, 1, 3)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$DocHeader/ns0:Attribute04"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </MOVE_TYPE> <!-- Monday 171: we gebruiken enkel 109 & 101 deze worden al bij de inslag meegegeven = movement type -->
                <ENTRY_QNT>
                    <xsl:choose>
                        <xsl:when test="$qty &lt; 1">
                            <xsl:value-of select="format-number($qty, '0.000')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="format-number($qty, '#.000')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </ENTRY_QNT>
                <ENTRY_UOM>
                    <xsl:value-of select="$OrigLine/ns0:OrderUnitofMeasureCode"/>
                </ENTRY_UOM>
                <PO_NUMBER>
                    <xsl:value-of select="$OrigLine/ns0:Attribute06"/>
                </PO_NUMBER>
                <PO_ITEM>
                    <xsl:value-of select="substring($OrigLine/ns0:Attributes/ns0:Attribute[ns0:Code = 'POLINENO']/ns0:Value, string-length($OrigLine/ns0:Attributes/ns0:Attribute[ns0:Code = 'POLINENO']/ns0:Value) - 4)"/>
                </PO_ITEM>
                <MVT_IND>B</MVT_IND> <!-- Monday 171: E1BP2017_GM_ITEM_CREATE/MVT_IND -> idd 'B' gebruiken -->
                <DELIV_NUMB_TO_SEARCH>
                    <xsl:value-of select="$OrigLine/ns0:Attribute01"/>
                </DELIV_NUMB_TO_SEARCH>
                <DELIV_ITEM_TO_SEARCH>
                    <xsl:if test="$split_info_part != 'fillerdata'">
                        <xsl:value-of select="tokenize($split_info_part, '/')[1]"/>
                    </xsl:if>
                </DELIV_ITEM_TO_SEARCH>
                
                <E1BP2017_GM_ITEM_CREATE1 SEGMENT="1">
                    <DELIV_NUMB>
                        <xsl:value-of select="$OrigLine/ns0:Attribute01" />
                    </DELIV_NUMB>
                    <DELIV_ITEM>
                        <xsl:value-of select="$OrigLine/ns0:Attributes/ns0:Attribute[ns0:Code = 'POLINENO']/ns0:Value" />
                    </DELIV_ITEM>
                </E1BP2017_GM_ITEM_CREATE1>
            </E1BP2017_GM_ITEM_CREATE>
            
            <xsl:call-template name="loop">
                <xsl:with-param name="i" select="$i + 1"/>
                <xsl:with-param name="max" select="$max"/>
                <xsl:with-param name="DocHeader" select="$DocHeader"/>
                <xsl:with-param name="DocLine" select="$DocLine"/>
                <xsl:with-param name="OrigLine" select="$OrigLine"/>
                <xsl:with-param name="splitInfo" select="$splitInfo"/>
                <xsl:with-param name="usedQty" select="$usedQty + $qty"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>