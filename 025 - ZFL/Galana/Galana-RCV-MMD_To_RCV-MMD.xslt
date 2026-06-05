<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="msxsl xsi" >
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//CustomerItem/Description | //CustomerItem/SearchDescription | //CustomerItem/Description2">
        <xsl:copy>
            <xsl:value-of select="substring(., 1, 50)"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//CustomerItem/DefaultCarrierQuantity">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="translate(., '0.', '') = ''">
                    <xsl:text>1</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="floor(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//UnitOfMeasure/QtyperUnitofMeasure">
        <xsl:copy>
            <xsl:value-of select="floor(.)"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//UnitOfMeasure/Length">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="translate(., '0.', '') = ''">
                    <xsl:text>60</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//UnitOfMeasure/Width">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="translate(., '0.', '') = ''">
                    <xsl:text>40</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//UnitOfMeasure/Height">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="translate(., '0.', '') = ''">
                    <xsl:text>20</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
