<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:array="http://www.w3.org/2005/xpath-functions/array"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                xmlns:functx="http://www.functx.com"
                xmlns:ns0="www.boltrics.nl/sendpostedsalesinvoice:v1.00"
                exclude-result-prefixes="#all"
                expand-text="yes"
                version="3.0">
    
    <xsl:output method="text" indent="yes" encoding="UTF-8"/>
    
    <xsl:variable name="sC" select="'&#59;'" />
    <xsl:variable name="cR" select="'&#xD;&#xa;'" />
    
    <xsl:variable name="PostingDateInvoice" select="format-date(xs:date(ns0:Message/ns0:PostedSalesInvoices/ns0:PostedSalesInvoice/ns0:PostingDate), '[D01][M01][Y0001]')"/>
    <xsl:variable name="CustomerNo" select="ns0:Message/ns0:PostedSalesInvoices/ns0:PostedSalesInvoice/ns0:Customer/ns0:Attribute01"/>
    <xsl:variable name="CurrencyCode" select="ns0:Message/ns0:PostedSalesInvoices/ns0:PostedSalesInvoice/ns0:CurrencyCode"/>
    
    <xsl:template match="/" mode="#all">
        <xsl:for-each select="//ns0:PostedSalesInvoices/ns0:PostedSalesInvoice">
            <xsl:call-template name="header"/>
        </xsl:for-each>
        <xsl:for-each select="//ns0:SalesInvoiceLines/ns0:SalesInvoiceLine">
            <xsl:call-template name="lines"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="header">
        <xsl:value-of select="functx:stringField('Nummering', xs:string(0), $sC,4)"/>
        <xsl:value-of select="functx:stringField('SAPboekingstype1', '212', $sC,3)"/>
        <xsl:value-of select="functx:stringField('SAPboekingstype2', '40', $sC,2)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Factuurnummer', ns0:No, $sC, 18)"/>
        <xsl:value-of select="functx:stringField('Filenummer HELEN', ((//ns0:PostedSalesInvoices/ns0:PostedSalesInvoice/ns0:WMSPostedDocNo)[1]), $sC, 40)"/>
        <xsl:value-of select="functx:stringField('Factuurdatum', $PostingDateInvoice, $sC, 8)"/>
        <xsl:value-of select="functx:stringField('Grootboekrekening','', $sC, 5)"/>
        <xsl:value-of select="functx:stringField('Klantnummer', $CustomerNo, $sC, 7)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 17)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Factuurbedrag', translate(ns0:AmountIncludingVAT, '.', ','), $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Standaard veld', 'J', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Currency', $CurrencyCode, $sC, 3)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('BTW Code', '', $sC, 2)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Filenummer HELEN', ((//ns0:PostedSalesInvoices/ns0:PostedSalesInvoice/ns0:WMSPostedDocNo)[1]), $sC, 40)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Costcenter', '', $sC, 16)"/>
        <xsl:value-of select="functx:stringField('Costunit', '', $sC, 7)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Standaard veld', 'N', $sC, 1)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Standaard veld', 'N', $cR, 1)"/>
    </xsl:template>
    
    
    
    <xsl:template name="lines">
        <xsl:value-of select="functx:stringField('Nummering', xs:string(position()), $sC,4)"/>
        <xsl:value-of select="functx:stringField('SAPboekingstype1', '212', $sC,3)"/>
        <xsl:value-of select="functx:stringField('SAPboekingstype2', '40', $sC,2)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Factuurnummer', ns0:DocumentNo, $sC, 18)"/>
        <xsl:value-of select="functx:stringField('Filenummer HELEN', ns0:WMSPostedDocNo, $sC, 40)"/>
        <xsl:value-of select="functx:stringField('Factuurdatum', $PostingDateInvoice, $sC, 8)"/>
        <xsl:value-of select="functx:stringField('Grootboekrekening', ns0:GeneralPostingGroup/ns0:SalesAccount, $sC, 5)"/>
        <xsl:value-of select="functx:stringField('Klantnummer', $CustomerNo, $sC, 7)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 17)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Factuurbedrag', translate(ns0:LineAmount, '.', ','), $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Standaard veld', 'J', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Currency', $CurrencyCode, $sC, 3)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('BTW Code', ns0:VATIdentifier, $sC, 2)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Filenummer HELEN', '', $sC, 40)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Costcenter', ns0:DimensionsSet/ns0:DimensionSet[ns0:DimensionCode='COSTCENTRE']/ns0:DimensionValueCode, $sC, 16)"/>
        <xsl:value-of select="functx:stringField('Costunit', ns0:DimensionsSet/ns0:DimensionSet[ns0:DimensionCode='COSTUNIT']/ns0:DimensionValueCode, $sC, 7)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Standaard veld', 'N', $sC, 1)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('leeg', '', $sC, 0)"/>
        <xsl:value-of select="functx:stringField('Standaard veld', 'N', $cR, 1)"/>
    </xsl:template>
    
    <xsl:function name="functx:stringField">
        <xsl:param name="name"/>
        <xsl:param name="value"/>
        <xsl:param name="char"/>
        <xsl:param name="length"/>
        
        <xsl:if test="($length != 0) and (string-length($value) > $length)">
            <xsl:message select="concat('Error: The length of Recordtype ',$name, ' exceeds the maximum length of ', $length)" terminate="yes"/>
        </xsl:if>
        
        <xsl:value-of select="if (string-length($value)  = 0) then concat('',$char) else concat($value, $char)"/>
    </xsl:function>
    
    <xsl:function name="functx:stringFieldLength">
        <xsl:param name="name"/>
        <xsl:param name="value"/>
        <xsl:param name="char"/>
        <xsl:param name="length"/>
        <xsl:variable name="spaces" select="string-join((for $i in 1 to $length return ' '), '')" />
        
        <xsl:if test="($length != 0) and (string-length($value) > $length)">
            <xsl:message select="concat('Error: The length of Recordtype ',$name, ' exceeds the maximum length of ', $length)" terminate="yes"/>
        </xsl:if>
        
        <xsl:value-of select="if (string-length($value)  = 0) then concat('0',$char) else concat(substring(concat($value, $spaces),1,$length), $char)"/>
    </xsl:function>
    
    
    <xsl:function name="functx:numberField">
        <xsl:param name="name"/>
        <xsl:param name="value"/>
        <xsl:param name="char"/>
        <xsl:param name="length"/>
        <xsl:variable name="zeros" select="string-join((for $i in 1 to $length return '0'), '')" />
        <xsl:variable name="string" select="concat($zeros, $value)"/>
        
        <xsl:if test="string-length($value) > $length">
            <xsl:message select="concat('Error: The length of Recordtype ',$name, ' exceeds the maximum length of ', $length)" terminate="yes"/>
        </xsl:if>
        
        <xsl:value-of select="concat(substring($string, string-length($string) -($length -1)),$char)"/>
    </xsl:function>
    
</xsl:stylesheet>