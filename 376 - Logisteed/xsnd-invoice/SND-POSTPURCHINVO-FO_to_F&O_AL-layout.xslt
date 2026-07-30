<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ns0="www.boltrics.nl/sendpostedpurchaseinvoice:v1.00"
                xmlns:f="urn:logisteed-purchinv"
                exclude-result-prefixes="#all"
                expand-text="yes"
                version="3.0">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:variable name="sC" as="xs:string" select="';'"/>
    <xsl:variable name="cR" as="xs:string" select="'&#xD;&#xA;'"/>

    <xsl:template match="/">
        <xsl:for-each select="ns0:Message/ns0:PostedPurchaseInvoices/ns0:PostedPurchaseInvoice">
            <xsl:variable name="invoice" as="element(ns0:PostedPurchaseInvoice)" select="."/>
            <xsl:variable name="source-lines" as="element(ns0:PurchaseInvoiceLine)*"
                          select="ns0:PurchaseInvoiceLines/ns0:PurchaseInvoiceLine[
                              normalize-space(ns0:LineAmount) != ''
                              and xs:decimal(ns0:LineAmount) != 0
                              and (
                                  normalize-space(ns0:Type) = '11'
                                  or exists(ns0:GeneralPostingGroup/ns0:PurchAccount)
                              )
                          ]"/>
            <xsl:if test="exists($source-lines)">
                <xsl:variable name="first-logistics-doc" as="xs:string" select="f:first-logistics-doc($invoice, $source-lines)"/>
                <xsl:variable name="posting-date" as="xs:string" select="f:format-date8(ns0:DocumentDate)"/>
                <xsl:variable name="vendor-attribute" as="xs:string"
                              select="normalize-space((ns0:PayToVendor/ns0:Attribute01, ns0:Vendor/ns0:Attribute01)[1])"/>
                <xsl:variable name="currency-code" as="xs:string"
                              select="if (normalize-space(ns0:CurrencyCode) != '') then normalize-space(ns0:CurrencyCode) else 'EUR'"/>
                <xsl:variable name="vendor-invoice-no" as="xs:string"
                              select="normalize-space((ns0:VendorInvoiceNo, ns0:No)[1])"/>

                <xsl:variable name="vat-groups" as="element(vat-group)*">
                    <xsl:for-each-group select="$source-lines"
                                        group-by="concat(f:line-vat-code(current-group()[1]), '|', f:line-vat-account(current-group()[1]))">
                        <xsl:variable name="vat-amount" as="xs:decimal"
                                      select="sum(for $line in current-group() return xs:decimal($line/ns0:AmountIncludingVAT) - xs:decimal($line/ns0:LineAmount))"/>
                        <xsl:variable name="vat-account" as="xs:string" select="f:line-vat-account(current-group()[1])"/>
                        <xsl:if test="$vat-amount != 0 or not($vat-account = ('112TK', '213TK'))">
                            <vat-group account="{$vat-account}"
                                       vat-id="{f:line-vat-code(current-group()[1])}"
                                       amount="{$vat-amount}"/>
                        </xsl:if>
                    </xsl:for-each-group>
                </xsl:variable>

                <xsl:value-of select="string-join((
                    '0',
                    '311',
                    '30',
                    '',
                    '',
                    $vendor-invoice-no,
                    $first-logistics-doc,
                    $posting-date,
                    '',
                    '',
                    $vendor-attribute,
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
                        '311',
                        '30',
                        '',
                        '',
                        $vendor-invoice-no,
                        f:line-logistics-doc(., $first-logistics-doc),
                        $posting-date,
                        f:line-account(.),
                        '',
                        $vendor-attribute,
                        '',
                        f:format-dec(ns0:LineAmount),
                        'J',
                        $currency-code,
                        '',
                        '',
                        '',
                        '',
                        '',
                        f:line-vat-code(.),
                        '',
                        '',
                        f:line-logistics-doc(., $first-logistics-doc),
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
                        '311',
                        '30',
                        '',
                        '',
                        $vendor-invoice-no,
                        $first-logistics-doc,
                        $posting-date,
                        string(@account),
                        '',
                        $vendor-attribute,
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
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:function name="f:first-logistics-doc" as="xs:string">
        <xsl:param name="invoice" as="element(ns0:PostedPurchaseInvoice)"/>
        <xsl:param name="lines" as="element(ns0:PurchaseInvoiceLine)*"/>
        <xsl:sequence select="normalize-space((
            $invoice/*[matches(local-name(), '(?i)(3pl.*doc.*no|wms.*doc.*no|logistics.*doc.*no)')],
            $lines/*[matches(local-name(), '(?i)(3pl.*doc.*no|wms.*doc.*no|logistics.*doc.*no)')][normalize-space() != '']
        )[1])"/>
    </xsl:function>

    <xsl:function name="f:line-logistics-doc" as="xs:string">
        <xsl:param name="line" as="element(ns0:PurchaseInvoiceLine)"/>
        <xsl:param name="fallback" as="xs:string"/>
        <xsl:variable name="line-value" as="xs:string"
                      select="normalize-space(($line/*[matches(local-name(), '(?i)(3pl.*doc.*no|wms.*doc.*no|logistics.*doc.*no)')])[1])"/>
        <xsl:sequence select="if ($line-value != '') then $line-value else $fallback"/>
    </xsl:function>

    <xsl:function name="f:line-account" as="xs:string">
        <xsl:param name="line" as="element(ns0:PurchaseInvoiceLine)"/>
        <xsl:sequence select="normalize-space((
            $line/ns0:GeneralPostingGroup/ns0:PurchAccount,
            $line/ns0:No
        )[1])"/>
    </xsl:function>

    <xsl:function name="f:line-vat-account" as="xs:string">
        <xsl:param name="line" as="element(ns0:PurchaseInvoiceLine)"/>
        <xsl:sequence select="normalize-space((
            $line/ns0:VATPostingGroup/*[matches(local-name(), '(?i)(purchase|purch).*vat.*account')],
            $line/ns0:VATPostingGroup/*[matches(local-name(), '(?i)vat.*account')][1]
        )[1])"/>
    </xsl:function>

    <xsl:function name="f:line-vat-code" as="xs:string">
        <xsl:param name="line" as="element(ns0:PurchaseInvoiceLine)"/>
        <xsl:sequence select="normalize-space((
            $line/*[matches(local-name(), '(?i)tax.*category')],
            $line/ns0:VATIdentifier
        )[1])"/>
    </xsl:function>

    <xsl:function name="f:dimension-value" as="xs:string">
        <xsl:param name="line" as="element(ns0:PurchaseInvoiceLine)"/>
        <xsl:param name="shortcut-name" as="xs:string"/>
        <xsl:param name="dimension-code" as="xs:string"/>
        <xsl:sequence select="normalize-space((
            $line/*[local-name() = $shortcut-name],
            $line/ns0:DimensionsSet/ns0:DimensionSet[ns0:DimensionCode = $dimension-code]/ns0:DimensionValueCode
        )[1])"/>
    </xsl:function>

    <xsl:function name="f:format-date8" as="xs:string">
        <xsl:param name="value" as="item()?"/>
        <xsl:sequence select="if (normalize-space(string($value)) = '') then '' else format-date(xs:date($value), '[D01][M01][Y0001]')"/>
    </xsl:function>

    <xsl:function name="f:format-dec" as="xs:string">
        <xsl:param name="value" as="item()?"/>
        <xsl:sequence select="if (normalize-space(string($value)) = '') then '' else replace(format-number(xs:decimal($value), '0.00'), '\\.', ',')"/>
    </xsl:function>

</xsl:stylesheet>