<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes = "#all"
                expand-text="yes" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//ns0:Message/ns0:Documents/ns0:Document" />
    </xsl:template>
    
    <xsl:template match="ns0:Message/ns0:Documents/ns0:Document">
        <DELVRY05>
            <IDOC BEGIN="1">
                <EDI_DC40 SEGMENT="1">
                    <TABNAM>EDI_DC40</TABNAM>
                    <DIRECT>1</DIRECT>
                    <DOCNUM>
                        <xsl:value-of select="concat(format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[Y0001][M01][D01][H01][m01][s01]'), substring(../../ns0:Header/ns0:MessageID, string-length(../../ns0:Header/ns0:MessageID) - 1))"/>
                    </DOCNUM>
                    <IDOCTYP>DELVRY05</IDOCTYP>
                    <MESTYP>WHSCON</MESTYP>
                    <MESCOD>IN</MESCOD>
                    <SNDPOR>
                        <xsl:choose>
                            <xsl:when test="contains(../../ns0:Header/ns0:Database, 'PROD')">POP</xsl:when>
                            <xsl:otherwise>POD</xsl:otherwise>
                        </xsl:choose>    
                    </SNDPOR>
                    <SNDPRT>LS</SNDPRT>
                    <SNDPRN>ZFL</SNDPRN>
                    <RCVPOR>PIDCLNT001</RCVPOR>
                    <RCVPRT>LS</RCVPRT>
                    <RCVPRN>GENERIX</RCVPRN>
                    <CREDAT>
                        <xsl:value-of select="format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[Y0001][M01][D01]')"/>
                    </CREDAT>
                    <CRETIM>
                        <xsl:value-of select="format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[H01][m01][s01]')"/>
                    </CRETIM>
                </EDI_DC40>
                <E1EDL20 SEGMENT="1">
                    <VBELN>{ns0:ExternalDocumentNo}</VBELN>
                    
                    <VSTEL>L124</VSTEL>
                    
                    <E1EDL18 SEGMENT="1">
                        <QUALF>PIC</QUALF>
                    </E1EDL18>
                    
                    <xsl:apply-templates select="ns0:DocumentLines/ns0:DocumentLine[ns0:Type = '1']"/>
                </E1EDL20>
            </IDOC>
        </DELVRY05>
    </xsl:template>
    
    <xsl:template match="ns0:DocumentLine">
        <xsl:variable name="DocLineNo">
            <xsl:choose>
                <xsl:when test="count(ns0:AttachedtoLineNo) = 0">
                    <xsl:value-of select="ns0:LineNo"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="ns0:AttachedtoLineNo"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <E1EDL24 SEGMENT="1">
            <POSNR>
                <xsl:value-of select="../ns0:DocumentLine[ns0:LineNo = $DocLineNo]/ns0:Attributes/ns0:Attribute[ns0:Code = 'LINENO']/ns0:Value"/>
            </POSNR>
            
            <MATNR>
                <xsl:value-of select="substring(concat('000000000000000000', ns0:ExternalNo), string-length(ns0:ExternalNo) + 1, 18)"/>
            </MATNR>
            
            <CHARG>
                <xsl:value-of select="../ns0:DocumentLine[ns0:LineNo = $DocLineNo]/ns0:ExternalBatchNo"/>
            </CHARG>
            
            <LFIMG>
                <xsl:choose>
                    <xsl:when test="ns0:PostedOrderQuantity &lt; 1">
                        <xsl:value-of select="format-number(ns0:PostedOrderQuantity, '0.000000')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="format-number(ns0:PostedOrderQuantity, '#.000000')"/>
                    </xsl:otherwise>
                </xsl:choose>    
            </LFIMG>
            
            <VRKME>
                <xsl:value-of select="../ns0:DocumentLine[ns0:LineNo = $DocLineNo]/ns0:OrderUnitofMeasureCode"/>
            </VRKME>
        </E1EDL24>
    </xsl:template>
</xsl:stylesheet>