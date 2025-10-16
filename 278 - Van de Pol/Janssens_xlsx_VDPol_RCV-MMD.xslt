<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
	exclude-result-prefixes="msxsl var"
	version="3.0">
	
	<xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
	
	<xsl:template match="/">
		<Messages>
			<xsl:apply-templates select="Rows/Row[position() &gt; 1]"/>
		</Messages>
	</xsl:template>
	
	<xsl:template match="Rows/Row">
		<Message>
			<Header>
				<CreationDateTime>
					<xsl:value-of select="current-dateTime()" />
				</CreationDateTime>
				<ProcesAction>
					<xsl:text>INSERT</xsl:text>
				</ProcesAction>
				<FromTradingPartner>
					<xsl:text>K0034</xsl:text>
				</FromTradingPartner>
				<ToTradingPartner>
					<xsl:text>Van de Pol</xsl:text>
				</ToTradingPartner>
			</Header>
			
			<CustomerItems>
				<CustomerItem>
					<ExternalNo>
						<xsl:value-of select="Colomn0"/>
					</ExternalNo>
					
					<Description>
						<xsl:value-of select="Colomn1"/>
					</Description>
					
					<BaseUnitofMeasure>
						<xsl:value-of select="Colomn2"/>
					</BaseUnitofMeasure>
					
					<TemplateName>
						<xsl:text>JANSITEM</xsl:text>
					</TemplateName>
					
					<ItemCategoryCode>
						<xsl:value-of select="Colomn3"/>
					</ItemCategoryCode>
					
					<UnitOfMeasures>
						<UnitOfMeasure>
							<Code>
								<xsl:value-of select="Colomn2"/>
							</Code>
							<QtyperUnitofMeasure>
								<xsl:text>1</xsl:text>
							</QtyperUnitofMeasure>
						</UnitOfMeasure>
					</UnitOfMeasures>
				</CustomerItem>
			</CustomerItems>
		</Message>
	</xsl:template>
</xsl:stylesheet>