<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/sendshipment:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes = "#all" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//ns0:Message/ns0:Documents/ns0:Document" />
    </xsl:template>
    
    <xsl:template match="ns0:Message/ns0:Documents/ns0:Document">
        <xsl:variable name="DepartureDate">
            <xsl:choose>
                <xsl:when test="ns0:DepartedDate != ''">
                    <xsl:value-of select="ns0:DepartedDate"/>
                </xsl:when>
                <xsl:when test="ns0:EstimatedDepartureDate != ''">
                    <xsl:value-of select="ns0:EstimatedDepartureDate"/>
                </xsl:when>
                <xsl:when test="ns0:PostingDate != ''">
                    <xsl:value-of select="ns0:PostingDate"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <DELVRY03>
            <IDOC BEGIN="1">
                <EDI_DC40 SEGMENT="1">
                    <TABNAM>EDI_DC40</TABNAM>
                    <MANDT>020</MANDT>
                    <DOCNUM>
                        <xsl:value-of select="concat(format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[Y0001][M01][D01][H01][m01][s01]'), substring(../../ns0:Header/ns0:MessageID, string-length(../../ns0:Header/ns0:MessageID) - 1))"/>
                    </DOCNUM>
                    <DIRECT>2</DIRECT>
                    <IDOCTYP>DELVRY03</IDOCTYP>
                    <MESTYP>SHPCON</MESTYP>
                    <SNDPOR>HARGO</SNDPOR>
                    <SNDPRT>LS</SNDPRT>
                    <SNDPRN>HARGO</SNDPRN>
                    <RCVPOR>SAPGPR</RCVPOR>
                    <RCVPRT>LS</RCVPRT>
                    <RCVPRN>SAPPRE</RCVPRN>
                    <CREDAT>
                        <xsl:value-of select="format-date($DepartureDate, '[Y0001][M01][D01]')"/>
                    </CREDAT>
                    <CRETIM>
                        <xsl:value-of select="format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[H01][m01][s01]')"/>
                    </CRETIM>
                    <SERIAL>
                        <xsl:value-of select="concat(format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[Y0001][M01][D01][H01][m01][s01]'), substring(../../ns0:Header/ns0:MessageID, string-length(../../ns0:Header/ns0:MessageID) - 1))"/>
                    </SERIAL>
                </EDI_DC40>
                <E1EDL20 SEGMENT="1">
                    <VBELN>
                        <xsl:value-of select="format-number(number(replace(ns0:ExternalDocumentNo, '[^0-9]', '')), '0000000000')"/>
                    </VBELN>
                    <E1EDL18 SEGMENT="1">
                        <QUALF>PGI</QUALF>
                    </E1EDL18>
                    <E1EDT13 SEGMENT="1">
                        <QUALF>006</QUALF>
                        <ISDD>
                            <xsl:value-of select="format-date($DepartureDate, '[Y0001][M01][D01]')"/>
                        </ISDD>
                    </E1EDT13>
                </E1EDL20>
            </IDOC>
        </DELVRY03>
    </xsl:template>
</xsl:stylesheet>