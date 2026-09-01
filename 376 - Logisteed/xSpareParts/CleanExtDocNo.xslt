<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:ns0="www.boltrics.nl/sendshipment:v1.00"
				exclude-result-prefixes="xsl">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:mode on-no-match="shallow-copy"/>

	<xsl:template match="ns0:ExternalDocumentNo">
		<xsl:copy-of select="."/>
		<ns0:CleanExternalDocumentNo>
			<xsl:value-of select="replace(string(.), '[^A-Za-z0-9]', '')"/>
		</ns0:CleanExternalDocumentNo>
	</xsl:template>
</xsl:stylesheet>
