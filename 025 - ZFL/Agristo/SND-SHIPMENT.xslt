<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/sendshipment:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:eit="http://www.elevate-it.be"
                exclude-result-prefixes = "#all"
                expand-text="yes" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <!-- ============================================================
         NAMED FUNCTIONS
         ============================================================ -->
    
    <xsl:function name="eit:padZeroLeft" as="xs:string">
        <xsl:param name="value"    as="xs:string"/>
        <xsl:param name="totalLen" as="xs:integer"/>
        <xsl:variable name="zeros">00000000000000000000</xsl:variable>
        
        <xsl:value-of select="substring(
                concat(substring($zeros, 1, $totalLen), $value),
                string-length($value) + 1,
                $totalLen)"/>
    </xsl:function>
    
    <!-- ============================================================
         TEMPLATES
         ============================================================ -->
    
    <xsl:template match="/">
        <xsl:apply-templates select="//ns0:Message/ns0:Documents/ns0:Document" />
    </xsl:template>
    
    <xsl:template match="ns0:Message/ns0:Documents/ns0:Document">
        <xsl:variable name="doc"           select="."/>
        <xsl:variable name="externalDocNo" select="xs:string(ns0:ExternalDocumentNo)"/>
        
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
                    <!-- <MESCOD>IN</MESCOD> -->
                    <SNDPOR>
                        <xsl:choose>
                            <xsl:when test="contains(../../ns0:Header/ns0:Database, 'PROD')">POP</xsl:when>
                            <xsl:otherwise>POD</xsl:otherwise>
                        </xsl:choose>
                    </SNDPOR>
                    <SNDPRT>LS</SNDPRT>
                    <SNDPRN>ZFL</SNDPRN>
                    <RCVPOR>
                        <xsl:choose>
                            <xsl:when test="contains(../../ns0:Header/ns0:Database, 'PROD')">SAPPRD</xsl:when>
                            <xsl:otherwise>SAPQAS</xsl:otherwise>
                        </xsl:choose>
                    </RCVPOR>
                    <RCVPRT>LS</RCVPRT>
                    <RCVPRN>
                        <xsl:choose>
                            <xsl:when test="contains(../../ns0:Header/ns0:Database, 'PROD')">PRDCLNT400</xsl:when>
                            <xsl:otherwise>QASCLNT400</xsl:otherwise>
                        </xsl:choose>    
                    </RCVPRN>
                    <CREDAT>
                        <xsl:value-of select="format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[Y0001][M01][D01]')"/>
                    </CREDAT>
                    <CRETIM>
                        <xsl:value-of select="format-dateTime(../../ns0:Header/ns0:CreationDateTime, '[H01][m01][s01]')"/>
                    </CRETIM>
                </EDI_DC40>
                
                <RETURNABLE_PACKAGINGS>
                    <xsl:if test="count(ns0:Carriers/ns0:Carrier[starts-with(ns0:CarrierTypeCode, 'EUR')]) &gt; 0">
                        <RETURNABLE_PACKAGING SEGMENT="1">
                            <CONTAINER_TYPE>EURO</CONTAINER_TYPE>
                            <CONTAINERS_IN>0</CONTAINERS_IN>
                            <CONTAINERS_IN_REFUSED>0</CONTAINERS_IN_REFUSED>
                            <CONTAINERS_OUT>{count(ns0:Carriers/ns0:Carrier[starts-with(ns0:CarrierTypeCode, 'EUR')])}</CONTAINERS_OUT>
                            <TRUCK_LIC>{ns0:VehicleNo}</TRUCK_LIC>
                            <TRAILER_LIC>{ns0:TrailerContainerNo}</TRAILER_LIC>
                            <CONTAINER_NR>{ns0:ContainerNo}</CONTAINER_NR>
                            <SEAL>{ns0:SealNo}</SEAL>
                            <TARRA>{ns0:Attributes/ns0:Attribute[ns0:Code = 'TAREWEIGHT']/ns0:Value}</TARRA>
                            <TEMPLOG1>{ns0:Attributes/ns0:Attribute[ns0:Code = 'TMD_NO']/ns0:Value}</TEMPLOG1>
                        </RETURNABLE_PACKAGING>
                    </xsl:if>
                    
                    <xsl:if test="count(ns0:Carriers/ns0:Carrier[not(starts-with(ns0:CarrierTypeCode, 'EUR'))]) &gt; 0">
                        <RETURNABLE_PACKAGING SEGMENT="1">
                            <CONTAINER_TYPE>UNKNOWN</CONTAINER_TYPE>
                            <CONTAINERS_IN>0</CONTAINERS_IN>
                            <CONTAINERS_IN_REFUSED>0</CONTAINERS_IN_REFUSED>
                            <CONTAINERS_OUT>{count(ns0:Carriers/ns0:Carrier[not(starts-with(ns0:CarrierTypeCode, 'EUR'))])}</CONTAINERS_OUT>
                            <TRUCK_LIC>{ns0:VehicleNo}</TRUCK_LIC>
                            <TRAILER_LIC>{ns0:TrailerContainerNo}</TRAILER_LIC>
                            <CONTAINER_NR>{ns0:ContainerNo}</CONTAINER_NR>
                            <SEAL>{ns0:SealNo}</SEAL>
                            <TARRA>{ns0:Attributes/ns0:Attribute[ns0:Code = 'TAREWEIGHT']/ns0:Value}</TARRA>
                            <TEMPLOG1>{ns0:Attributes/ns0:Attribute[ns0:Code = 'TMD_NO']/ns0:Value}</TEMPLOG1>
                        </RETURNABLE_PACKAGING>
                    </xsl:if>
                </RETURNABLE_PACKAGINGS>
                
                <E1EDL20 SEGMENT="1">
                    <VBELN>{ns0:ExternalDocumentNo}</VBELN>
                    
                    <VSTEL>L124</VSTEL>
                    
                    <E1EDL18 SEGMENT="1">
                        <QUALF>PIC</QUALF>
                    </E1EDL18>
                    
                    <xsl:variable name="sortedContents" as="element()*">
                        <xsl:perform-sort select="ns0:Carriers/ns0:Carrier/ns0:Contents/ns0:Content">
                            <xsl:sort select="concat(eit:padZeroLeft(xs:string(ns0:DocumentLineNo), 10), '-', ns0:CarrierNo)"/>
                        </xsl:perform-sort>
                    </xsl:variable>
                    
                    <!-- Pass 1: all E1EDL24 delivery lines -->
                    <xsl:for-each select="$sortedContents">
                        <xsl:variable name="relLineNo" select="xs:string(ns0:DocumentLineNo)"/>
                        <xsl:variable name="posNr"     select="900000 + position()"/>
                        <xsl:variable name="matchedLine" select="$doc/ns0:DocumentLines/ns0:DocumentLine[ns0:LineNo = $relLineNo]"/>
                        <xsl:variable name="attachedTo"  select="xs:string($matchedLine/ns0:AttachedtoLineNo)"/>
                        <xsl:variable name="docLineNo"
                            select="if ($attachedTo != '' and $attachedTo != '-1')
                                    then $attachedTo
                                else $relLineNo"/>
                        
                        <xsl:call-template name="E1EDL24">
                            <xsl:with-param name="content"   select="."/>
                            <xsl:with-param name="posNr"     select="$posNr"/>
                            <xsl:with-param name="docLineNo" select="$docLineNo"/>
                            <xsl:with-param name="doc"       select="$doc"/>
                        </xsl:call-template>
                    </xsl:for-each>
                    
                    <!-- Pass 2: all E1EDL37 handling units (same order, same POSNR) -->
                    <xsl:for-each select="$sortedContents">
                        <xsl:call-template name="E1EDL37">
                            <xsl:with-param name="content"       select="."/>
                            <xsl:with-param name="posNr"         select="900000 + position()"/>
                            <xsl:with-param name="externalDocNo" select="$externalDocNo"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </E1EDL20>
            </IDOC>
        </DELVRY05>
    </xsl:template>
    
    <xsl:template name="E1EDL24">
        <xsl:param name="content" as="element()" />
        <xsl:param name="posNr" />
        <xsl:param name="docLineNo" />
        <xsl:param name="doc" />
        
        <E1EDL24 SEGMENT="1">
            <POSNR>{$posNr}</POSNR>
            
            <MATNR>{eit:padZeroLeft(xs:string($content/ns0:ExternalNo), 18)}</MATNR>
            
            <CHARG>{$content/ns0:ExternalBatchNo}</CHARG>
            
            <LFIMG></LFIMG>
            
            <LGMNG>
                <xsl:choose>
                    <xsl:when test="$content/ns0:QuantityBase &lt; 1">
                        <xsl:value-of select="format-number($content/ns0:QuantityBase, '0.000000')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="format-number($content/ns0:QuantityBase, '#.000000')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </LGMNG>
            
            <VRKME></VRKME>
            
            <MEINS>{$content/ns0:BaseUnitofMeasureCode}</MEINS>
            
            <HIPOS>{$doc/ns0:DocumentLines/ns0:DocumentLine[ns0:LineNo = $docLineNo]/ns0:Attributes/ns0:Attribute[ns0:Code = 'LINENO']/ns0:Value}</HIPOS>
            
            <E1EDL19 SEGMENT="1">
                <QUALF>BAS</QUALF>
            </E1EDL19>
        </E1EDL24>
    </xsl:template>
    
    <xsl:template name="E1EDL37">
        <xsl:param name="content" as="element()" />
        <xsl:param name="posNr" />
        <xsl:param name="externalDocNo" />
        
        <E1EDL37 SEGMENT="1">
            <EXIDV>{eit:padZeroLeft(xs:string($content/ns0:CarrierNo), 20)}</EXIDV>
            
            <VHILM>
                <xsl:choose>
                    <xsl:when test="starts-with(ns0:CarrierTypeCode, 'EUR')">EURO</xsl:when>
                    <xsl:otherwise>UNKNOWN</xsl:otherwise>
                </xsl:choose>    
            </VHILM>
            
            <E1EDL44 SEGMENT="1">
                <VELIN>1</VELIN>
                
                <VBELN>{$externalDocNo}</VBELN>
                
                <POSNR>{$posNr}</POSNR>
                
                <EXIDV>{eit:padZeroLeft(xs:string($content/ns0:CarrierNo), 20)}</EXIDV>
                
                <VEMNG>
                    <xsl:choose>
                        <xsl:when test="$content/ns0:QuantityBase &lt; 1">
                            <xsl:value-of select="format-number($content/ns0:QuantityBase, '0.000000')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="format-number($content/ns0:QuantityBase, '#.000000')"/>
                        </xsl:otherwise>
                    </xsl:choose>    
                </VEMNG>
                
                <VEMEH>{$content/ns0:BaseUnitofMeasureCode}</VEMEH>
                
                <MATNR>{eit:padZeroLeft(xs:string($content/ns0:ExternalNo), 18)}</MATNR>
                
                <CHARG>{$content/ns0:ExternalBatchNo}</CHARG>
                
            </E1EDL44>
        </E1EDL37>
    </xsl:template>
</xsl:stylesheet>