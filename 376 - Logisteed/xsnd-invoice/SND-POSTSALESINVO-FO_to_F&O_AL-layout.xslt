<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ns0="www.boltrics.nl/sendpostedsalesinvoice:v1.00"
                xmlns:f="urn:logisteed-salesinv"
                exclude-result-prefixes="#all"
                expand-text="yes"
                version="3.0">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:variable name="sC" as="xs:string" select="';'"/>
    <xsl:variable name="cR" as="xs:string" select="'&#xD;&#xA;'"/>

    <xsl:template match="/">
        <xsl:for-each select="ns0:Message/ns0:PostedSalesInvoices/ns0:PostedSalesInvoice">
            <xsl:variable name="invoice" as="element(ns0:PostedSalesInvoice)" select="."/>
            <xsl:variable name="source-lines" as="element(ns0:SalesInvoiceLine)*"
                          select="ns0:SalesInvoiceLines/ns0:SalesInvoiceLine[normalize-space(ns0:LineAmount) != '' and xs:decimal(ns0:LineAmount) != 0]"/>
            <xsl:if test="exists($source-lines)">
                <xsl:variable name="first-logistics-doc" as="xs:string" select="f:first-logistics-doc($invoice)"/>
                <xsl:variable name="posting-date" as="xs:string" select="f:format-date8(ns0:PostingDate)"/>
                <xsl:variable name="customer-attribute" as="xs:string"
                              select="normalize-space((ns0:BillToCustomer/ns0:Attribute01, ns0:Customer/ns0:Attribute01)[1])"/>
                <xsl:variable name="currency-code" as="xs:string"
                              select="if (normalize-space(ns0:CurrencyCode) != '') then normalize-space(ns0:CurrencyCode) else 'EUR'"/>
                <xsl:variable name="vat-groups" as="element(vat-group)*">
                    <xsl:for-each-group select="$source-lines"
                                        group-by="concat(normalize-space(ns0:VATIdentifier), '|', normalize-space(ns0:VATPostingGroup/ns0:SalesVATAccount))">
                        <xsl:variable name="vat-amount" as="xs:decimal"
                                      select="sum(for $line in current-group() return xs:decimal($line/ns0:AmountIncludingVAT) - xs:decimal($line/ns0:LineAmount))"/>
                        <xsl:variable name="sales-vat-account" as="xs:string"
                                      select="normalize-space(current-group()[1]/ns0:VATPostingGroup/ns0:SalesVATAccount)"/>
                        <xsl:if test="$vat-amount != 0 or not($sales-vat-account = ('112TK', '213TK'))">
                            <vat-group account="{$sales-vat-account}"
                                       vat-id="{normalize-space(current-group()[1]/ns0:VATIdentifier)}"
                                       amount="{$vat-amount}"/>
                        </xsl:if>
                    </xsl:for-each-group>
                </xsl:variable>

                <xsl:value-of select="string-join((
                    '0',
                    '312',
                    '40',
                    '',
                    '',
                    string(ns0:No),
                    $first-logistics-doc,
                    $posting-date,
                    '',
                    $customer-attribute,
                    '',
                    '',
                    f:format-dec(ns0:AmountIncludingVAT),
                    'J',
                    $currency-code,
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    $first-logistics-doc,
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    'N',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    'N'
                ), $sC)"/>
                <xsl:value-of select="$cR"/>

                <xsl:for-each select="$source-lines">
                    <xsl:value-of select="string-join((
                        string(position()),
                        '312',
                        '40',
                        '',
                        '',
                        string(ns0:DocumentNo),
                        $first-logistics-doc,
                        $posting-date,
                        f:line-account(.),
                        $customer-attribute,
                        '',
                        '',
                        f:format-dec(ns0:LineAmount),
                        'J',
                        $currency-code,
                        '',
                        '',
                        '',
                        '',
                        '',
                        normalize-space(ns0:VATIdentifier),
                        '',
                        '',
                        '',
                        '',
                        '',
                        f:dimension-value(., 'ShortcutDimension1Code', 'COSTCENTRE'),
                        f:dimension-value(., 'ShortcutDimension2Code', 'COSTUNIT'),
                        '',
                        '',
                        '',
                        'N',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        'N'
                    ), $sC)"/>
                    <xsl:value-of select="$cR"/>
                </xsl:for-each>

                <xsl:for-each select="$vat-groups">
                    <xsl:value-of select="string-join((
                        string(count($source-lines) + position()),
                        '312',
                        '40',
                        '',
                        '',
                        string($invoice/ns0:No),
                        $first-logistics-doc,
                        $posting-date,
                        string(@account),
                        $customer-attribute,
                        '',
                        '',
                        f:format-dec(@amount),
                        'J',
                        $currency-code,
                        '',
                        '',
                        '',
                        '',
                        '',
                        string(@vat-id),
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        'N',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        'N'
                    ), $sC)"/>
                    <xsl:value-of select="$cR"/>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:function name="f:first-logistics-doc" as="xs:string">
        <xsl:param name="invoice" as="element(ns0:PostedSalesInvoice)"/>
        <xsl:sequence select="normalize-space((
            $invoice/*[local-name() = 'WMSPostedDocNo'],
            $invoice/ns0:SalesInvoiceLines/ns0:SalesInvoiceLine/*[local-name() = 'WMSPostedDocNo'][normalize-space() != ''],
            $invoice/ns0:SalesInvoiceLines/ns0:SalesInvoiceLine/ns0:ParentDocumentNo[normalize-space() != ''],
            $invoice/ns0:SalesInvoiceLines/ns0:SalesInvoiceLine/ns0:InvoiceInformation/ns0:InvoiceInformationLine/ns0:GeneratedFromDocumentNo[normalize-space() != '']
        )[1])"/>
    </xsl:function>

    <xsl:function name="f:format-date8" as="xs:string">
        <xsl:param name="value" as="item()?"/>
        <xsl:sequence select="if (normalize-space(string($value)) = '') then '' else format-date(xs:date($value), '[D01][M01][Y0001]')"/>
    </xsl:function>

    <xsl:function name="f:format-dec" as="xs:string">
        <xsl:param name="value" as="item()?"/>
        <xsl:sequence select="if (normalize-space(string($value)) = '') then '' else format-number(xs:decimal($value), '0.00')"/>
    </xsl:function>

    <xsl:function name="f:line-account" as="xs:string">
        <xsl:param name="line" as="element(ns0:SalesInvoiceLine)"/>
        <xsl:sequence select="normalize-space((
            $line/ns0:GeneralPostingGroup/ns0:SalesAccount,
            $line/ns0:No
        )[1])"/>
    </xsl:function>

    <xsl:function name="f:dimension-value" as="xs:string">
        <xsl:param name="line" as="element(ns0:SalesInvoiceLine)"/>
        <xsl:param name="shortcut-name" as="xs:string"/>
        <xsl:param name="dimension-code" as="xs:string"/>
        <xsl:sequence select="normalize-space((
            $line/*[local-name() = $shortcut-name],
            $line/ns0:DimensionsSet/ns0:DimensionSet[ns0:DimensionCode = $dimension-code]/ns0:DimensionValueCode
        )[1])"/>
    </xsl:function>

</xsl:stylesheet>