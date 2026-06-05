<xsl:stylesheet version="3.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/2005/xpath-functions"
                xmlns:ns0="www.boltrics.nl/sendtmsdocument:v1.00">
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//ns0:Message/ns0:Documents/ns0:Document" />
    </xsl:template>
    
    <xsl:template match="//ns0:Message/ns0:Documents/ns0:Document">
        <!-- CONVERT INPUT TO XML FOR JSON -->
        <xsl:variable name="xml">
            <map>
                <map key="relation">
                    <string key="type">
                        <xsl:text>in_sequence</xsl:text>
                    </string>
                    <array key="tracking_numbers">
                        <xsl:for-each select="ns0:SubDocuments/ns0:SubDocument/ns0:Sections/ns0:Section">
                            <xsl:choose>
                                <xsl:when test="(ns0:FromAddressNo != '') and (ns0:ToAddressNo != '')">
                                    <xsl:call-template name="WriteTrackingNo">
                                        <xsl:with-param name="n">2</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="(ns0:FromAddressNo != '') and (ns0:ToAddressNo = '')">
                                    <xsl:call-template name="WriteTrackingNo">
                                        <xsl:with-param name="n">1</xsl:with-param>
                                        <xsl:with-param name="type">from</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="(ns0:FromAddressNo = '') and (ns0:ToAddressNo != '')">
                                    <xsl:call-template name="WriteTrackingNo">
                                        <xsl:with-param name="n">1</xsl:with-param>
                                        <xsl:with-param name="type">to</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="(count(ns0:FromAddressNo) &gt; 0) and (count(ns0:ToAddressNo) = 0)">
                                    <xsl:call-template name="WriteTrackingNo">
                                        <xsl:with-param name="n">1</xsl:with-param>
                                        <xsl:with-param name="type">from</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="(count(ns0:FromAddressNo) = 0) and (count(ns0:ToAddressNo) &gt; 0)">
                                    <xsl:call-template name="WriteTrackingNo">
                                        <xsl:with-param name="n">1</xsl:with-param>
                                        <xsl:with-param name="type">to</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </array>
                </map>
            </map>
        </xsl:variable>
        
        <!-- OUTPUT -->
        <xsl:value-of select="xml-to-json($xml)"/>
    </xsl:template>
    
    <xsl:template name="WriteTrackingNo">
        <xsl:param name="n"></xsl:param>
        <xsl:param name="type"></xsl:param>

        <xsl:choose>
            <xsl:when test="$n &gt; 0">
                <xsl:choose>
                    <xsl:when test="$type = ''">
                        <xsl:call-template name="CreateTrackingNo">
                            <xsl:with-param name="type">from</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="CreateTrackingNo">
                            <xsl:with-param name="type">to</xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="CreateTrackingNo">
                            <xsl:with-param name="type">
                                <xsl:value-of select="$type"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="CreateTrackingNo">
        <xsl:param name="type"></xsl:param>
        
        <string>
            <xsl:value-of select="ns0:No"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="ns0:SequenceNo"/>
            <xsl:choose>
                <xsl:when test="$type = 'from'">
                    <xsl:text>-P</xsl:text>
                </xsl:when>
                <xsl:when test="$type = 'to'">
                    <xsl:text>-D</xsl:text>
                </xsl:when>
            </xsl:choose>
        </string>
    </xsl:template>
</xsl:stylesheet>