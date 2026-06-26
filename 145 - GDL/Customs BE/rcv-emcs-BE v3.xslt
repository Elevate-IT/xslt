<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet 
	version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	exclude-result-prefixes="msxsl">
	
	<xsl:output omit-xml-declaration="yes" indent="yes"/>
	
	<xsl:param name="guid" />
	
	<xsl:template match="*">
		<Message xmlns:ns0="www.boltrics.nl/receiveemcsdocument:v3.40">
			<Header>
				<MessageID><xsl:value-of select="$guid"/></MessageID>
				<ProcesAction>INSERT</ProcesAction>
				<FromTradingPartner>NDEA.NL</FromTradingPartner>
				<ToTradingPartner>BOLTRICS</ToTradingPartner>
			</Header>
			
			<Body><xsl:text disable-output-escaping="yes"></xsl:text>
				<xsl:copy-of select="/*"/>
				<xsl:text disable-output-escaping="yes"></xsl:text></Body>
		</Message>
	</xsl:template>
</xsl:stylesheet>