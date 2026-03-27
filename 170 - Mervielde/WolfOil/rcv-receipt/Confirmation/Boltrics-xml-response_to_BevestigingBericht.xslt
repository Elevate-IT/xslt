<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/2005/xpath-functions"
                xmlns:mf="urn:mervielde:wolfoil:confirmation"
                exclude-result-prefixes="xs mf">
    <xsl:output method="text" encoding="UTF-8"/>

    <!-- responseId is supplied as a parameter by the EDI tool flow -->
    <xsl:param name="responseId" as="xs:string" select="''"/>

    <!-- ============================================================
         Input format (EDI tool – JSON converted to XML):
           <xml odata.context="...">
             <value>&lt;?xml ...?&gt;&lt;Response&gt;...&lt;/Response&gt;</value>
           </xml>

         The <value> text is the entity-encoded Boltrics Response XML.
         parse-xml() decodes it and returns a document node.
         ============================================================ -->
    <xsl:template match="/xml">
        <xsl:sequence select="mf:build-output(parse-xml(value))"/>
    </xsl:template>

    <xsl:function name="mf:build-output" as="xs:string">
        <xsl:param name="response" as="document-node(element(Response))"/>

        <xsl:variable name="is-success" as="xs:boolean"
                      select="normalize-space($response/Response/Status) = 'Succeeded'"/>
        <xsl:variable name="json-output">
            <map>
                <string key="editype">I</string>
                <string key="responseId">
                    <xsl:value-of select="$responseId"/>
                </string>
                <string key="Feedback">
                    <xsl:value-of select="if ($is-success) then 'OK' else 'error'"/>
                </string>
                <xsl:if test="not($is-success)">
                    <string key="Exception">
                        <xsl:value-of select="normalize-space($response/Response/Exception)"/>
                    </string>
                </xsl:if>
                <string key="referentieMervielde"/>
            </map>
        </xsl:variable>

        <xsl:sequence select="xml-to-json($json-output, map { 'indent': true() })"/>
    </xsl:function>

</xsl:stylesheet>
