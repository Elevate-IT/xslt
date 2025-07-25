<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes = "#all" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//ns0:Message/ns0:Documents/ns0:Document" />
    </xsl:template>
    
    <xsl:template match="ns0:Message/ns0:Documents/ns0:Document">
        <ZMBGMCR01>
            <IDOC BEGIN="1">
                <EDI_DC40 SEGMENT="1">
                    <MANDT>020</MANDT>
                    <DOCNUM>
                        <xsl:value-of select="concat(format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[Y0001][M01][D01][H01][m01][s01]'), substring(../../ns0:Header/ns0:MessageID, string-length(../../ns0:Header/ns0:MessageID) - 1))"/>
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
                        <xsl:value-of select="format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[Y0001][M01][D01]')"/>
                    </CREDAT>
                    <CRETIM>
                        <xsl:value-of select="format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[H01][m01][s01]')"/>
                    </CRETIM>
                    <SERIAL>
                        <xsl:value-of select="concat(format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[Y0001][M01][D01][H01][m01][s01]'), substring(../../ns0:Header/ns0:MessageID, string-length(../../ns0:Header/ns0:MessageID) - 1))"/>
                    </SERIAL>
                </EDI_DC40>
                <Z1ZMBGMCR SEGMENT="1">
                    <E1BP2017_GM_HEAD_01 SEGMENT="1">
                        <PSTNG_DATE>
                            <xsl:value-of select="format-date(ns0:PostingDate, '[Y0001][M01][D01]')"/>
                        </PSTNG_DATE>
                        <DOC_DATE>
                            <xsl:value-of select="format-date(ns0:DocumentDate, '[Y0001][M01][D01]')"/>
                        </DOC_DATE>
                        <REF_DOC_NO>
                            <xsl:value-of select="substring(concat('0000000000000000', replace(ns0:ExternalDocumentNo, ' ', '')), string-length(replace(ns0:ExternalDocumentNo, ' ', '')) + 1, 16)"/>
                        </REF_DOC_NO>
                        <PR_UNAME>INTERFAC</PR_UNAME>
                    </E1BP2017_GM_HEAD_01>
                    <E1BP2017_GM_CODE SEGMENT="1">
                        <GM_CODE>01</GM_CODE> <!-- CHECK possible values: 01, 04 -->
                    </E1BP2017_GM_CODE>
                    
                    <xsl:for-each select="ns0:DocumentLines/ns0:DocumentLine[ns0:Type = '1']">
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

                        <E1BP2017_GM_ITEM_CREATE SEGMENT="1">
                            <MATERIAL>
                                <xsl:value-of select="substring(concat('000000000000000000', ns0:ExternalNo), string-length(ns0:ExternalNo) + 1, 18)"/>
                            </MATERIAL>
                            <PLANT>5622</PLANT>
                            <STGE_LOC>A100</STGE_LOC>
                            <BATCH>
                                <xsl:value-of select="../ns0:DocumentLine[ns0:LineNo = $LineNo]/ns0:ExternalBatchNo"/>
                            </BATCH>
                            <MOVE_TYPE>109</MOVE_TYPE> <!-- CHECK possible values: -->
                            <!-- Movement Type	Description	                                    Notes
                                    109	        Ashland Intra company PO receipt.	
                                    101	        Goods receipt on material from external vendor	
                                    309	        Material to Material transfer	                GOOD STOCK ONLY
                                    311	        Location Or Batch Change	                    GOOD STOCK ONLY
                                    325	        Location Or Batch Change	                    BLOCKED STOCK ONLY
                                    343	        Blocked to Unrestricted	
                                    344	        Unrestricted to blocked	
                                    551	        Scrapping	                                    GOOD STOCK ONLY
                                    552	        Scrapping reversal	                            GOOD STOCK ONLY
                                    555	        Scrap from blocked	                            BLOCKED STOCK ONLY
                                    556	        UnScrap to blocked	                            BLOCKED STOCK ONLY -->
                            <ENTRY_QNT>
                                <xsl:choose>
                                    <xsl:when test="ns0:PostedOrderQuantity &lt; 1">
                                        <xsl:value-of select="format-number(ns0:PostedOrderQuantity, '0.000')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="format-number(ns0:PostedOrderQuantity, '#.000')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ENTRY_QNT>
                            <ENTRY_UOM>
                                <xsl:value-of select="../ns0:DocumentLine[ns0:LineNo = $LineNo]/ns0:OrderUnitofMeasureCode"/>
                            </ENTRY_UOM>
                            <PO_NUMBER>
                                <xsl:value-of select="../ns0:DocumentLine[ns0:LineNo = $LineNo]/ns0:Attribute06"/>
                            </PO_NUMBER>
                            <PO_ITEM>
                                <xsl:value-of select="../ns0:DocumentLine[ns0:LineNo = $LineNo]/ns0:Attributes/ns0:Attribute[ns0:Code = 'POLINENO']/ns0:Value"/>
                            </PO_ITEM>
                            <MVT_IND>B</MVT_IND> <!-- CHECK -->
                            <DELIV_NUMB_TO_SEARCH>
                                <xsl:value-of select="../ns0:DocumentLine[ns0:LineNo = $LineNo]/ns0:Attribute01"/>
                            </DELIV_NUMB_TO_SEARCH>
                            <DELIV_ITEM_TO_SEARCH></DELIV_ITEM_TO_SEARCH> <!-- CHECK -->

                            <!-- CHECK E1BP2017_GM_ITEM_CREATE1 needed? -->
                            <!-- <E1BP2017_GM_ITEM_CREATE1 SEGMENT="1">
                                <DELIV_NUMB>0852835037</DELIV_NUMB>
                                <DELIV_ITEM>000010</DELIV_ITEM>
                            </E1BP2017_GM_ITEM_CREATE1> -->
                        </E1BP2017_GM_ITEM_CREATE>
                    </xsl:for-each>
                </Z1ZMBGMCR>
            </IDOC>
        </ZMBGMCR01>
    </xsl:template>
</xsl:stylesheet>