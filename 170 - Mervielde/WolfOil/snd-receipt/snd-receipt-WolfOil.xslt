<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/2005/xpath-functions"
                xmlns:ns0="www.boltrics.nl/sendreceipt:v1.00"
                exclude-result-prefixes="xs ns0">
    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:template match="/ns0:Message">
        <xsl:variable name="json-output">
            <array>
                <xsl:for-each-group
                    select="ns0:Documents/ns0:Document/ns0:DocumentLines/ns0:DocumentLine/ns0:DocumentDetailLines/ns0:DocumentDetailLine"
                    group-by="concat(normalize-space(ns0:CarrierNo), '|', normalize-space((parent::ns0:DocumentDetailLines/parent::ns0:DocumentLine/ns0:Attributes/ns0:Attribute[ns0:Code='WOLFMSGID'][1]/ns0:Value)[1]))">

                    <xsl:sort select="normalize-space(ns0:CarrierNo)"/>
                    <xsl:sort select="xs:integer(ns0:LineNo)"/>

                    <xsl:variable name="first-detail" select="current-group()[1]"/>
                    <xsl:variable name="document-line" select="$first-detail/parent::ns0:DocumentDetailLines/parent::ns0:DocumentLine"/>
                    <xsl:variable name="document" select="$document-line/parent::ns0:DocumentLines/parent::ns0:Document"/>
                    <xsl:variable name="wolf-msg-id" as="xs:string"
                                  select="normalize-space(($document-line/ns0:Attributes/ns0:Attribute[ns0:Code='WOLFMSGID'][1]/ns0:Value)[1])"/>
                    <xsl:variable name="aantal-liters" as="xs:decimal"
                                  select="sum(for $line in current-group() return xs:decimal(normalize-space($line/ns0:Quantity)))"/>

                    <map>
                        <string key="editype">I</string>
                        <!-- <string key="opdrachtId">
                            <xsl:value-of select="$wolf-msg-id"/>
                        </string> -->
                        <string key="responseId">
                            <xsl:value-of select="$wolf-msg-id"/>
                        </string>
                        <number key="AantalLitersBev">
                            <xsl:value-of select="$aantal-liters"/>
                        </number>
                        <!-- <string key="FinaleStock"/> -->
                        <string key="Tank">
                            <xsl:value-of select="normalize-space($first-detail/ns0:CarrierNo)"/>
                        </string>
                        <string key="DatumUitgevoerd">
                            <xsl:value-of select="normalize-space($document/ns0:PostingDate)"/>
                        </string>
                        <string key="MoederProduct">
                            <xsl:value-of select="normalize-space($document-line/ns0:ExternalNo)"/>
                        </string>
                        <string key="referentieMervielde">
                            <xsl:value-of select="normalize-space($document/ns0:No)"/>
                        </string>
                    </map>
                </xsl:for-each-group>
            </array>
        </xsl:variable>

        <xsl:sequence select="xml-to-json($json-output, map { 'indent': true() })"/>
    </xsl:template>
</xsl:stylesheet>
