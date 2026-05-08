<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
	exclude-result-prefixes="msxsl var"
	version="3.0">
	
	<xsl:output omit-xml-declaration="yes" method="xml" version="1.0" indent="true" />
	
	<xsl:template match="/">
		<Messages>
			<xsl:apply-templates select="Root/Item[position() &gt; 1]"/>
		</Messages>
	</xsl:template>
	
	<xsl:template match="Item">
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
						<xsl:value-of select="Column0"/>
					</ExternalNo>
					
					<Description>
						<xsl:value-of select="substring(Column1, 1, 50)"/>
					</Description>
					
					<SearchDescription>
						<xsl:value-of select="substring(Column1, 1, 50)"/>
					</SearchDescription>
					
					<BaseUnitofMeasure>
						<xsl:value-of select="Column2"/>
					</BaseUnitofMeasure>
					<UnitofMeasureatReceipt>
						<xsl:value-of select="Column2"/>
					</UnitofMeasureatReceipt>
					<UnitofMeasureatShipment>
						<xsl:value-of select="Column2"/>
					</UnitofMeasureatShipment>
					<UnitofMeasureatStorage>
						<xsl:value-of select="Column2"/>
					</UnitofMeasureatStorage>
					
					<TemplateName>
						<xsl:text>JANSITEM</xsl:text>
					</TemplateName>
					
					<ItemNo>
						<xsl:text>STD</xsl:text>
					</ItemNo>
					
					<ProductGroupCode>
						<xsl:value-of select="Column3"/>
					</ProductGroupCode>
					
					<UnitOfMeasures>
						<UnitOfMeasure>
							<Code>
								<xsl:value-of select="Column2"/>
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