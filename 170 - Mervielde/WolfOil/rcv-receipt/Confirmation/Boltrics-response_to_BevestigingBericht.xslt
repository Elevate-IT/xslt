<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/2005/xpath-functions"
                xmlns:mf="urn:mervielde:wolfoil:confirmation"
                exclude-result-prefixes="xs mf">
    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:param name="responseId" as="xs:string" select="''"/>

    <!-- ============================================================
         Entry point A – EDI tool
         The tool must extract the XML string from the JSON 'value'
         field and supply it as the source document.
         Saxon .NET example:
           var builder = processor.NewDocumentBuilder();
           var source  = builder.Build(new StringReader(responseXml));
           xslt.InitialContextNode = source;
         ============================================================ -->
    <xsl:template match="/Response">
        <xsl:sequence select="mf:build-output(root(.))"/>
    </xsl:template>

    <!-- ============================================================
         Entry point B – VS Code / command-line
         Run with: -it  json-uri="path/to/response.json"
         Saxon reads the OData JSON, extracts 'value', parses the XML.
         ============================================================ -->
    <xsl:param name="json-uri" as="xs:string?" select="()"/>

    <xsl:template name="xsl:initial-template">
        <xsl:variable name="resolved-uri" as="xs:anyURI"
                      select="if (matches($json-uri, '^[A-Za-z]:[\\/]'))
                              then xs:anyURI(concat('file:///', replace(replace($json-uri, '\\', '/'), ' ', '%20')))
                              else resolve-uri($json-uri, static-base-uri())"/>
        <xsl:sequence select="mf:build-output(parse-xml(string(json-doc($resolved-uri)?value)))"/>
    </xsl:template>

    <!-- ============================================================
         Core output builder – shared by both entry points
         ============================================================ -->
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

        <xsl:sequence select="xml-to-json($json-output)"/>
    </xsl:function>

</xsl:stylesheet>