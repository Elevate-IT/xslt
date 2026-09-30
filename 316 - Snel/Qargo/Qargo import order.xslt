<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/2005/xpath-functions"
                xmlns:ns0="www.boltrics.nl/sendtripqargo:v1.00">
  <xsl:output method="text" encoding="UTF-8" />

  <xsl:template match="/">
    <xsl:apply-templates select="ns0:Message/ns0:Trips/ns0:Trip[1]" />
  </xsl:template>

  <xsl:template match="ns0:Trip">
    <xsl:variable name="firstDoc" select="ns0:TripLines/ns0:TripLine[1]/ns0:Documents/ns0:Document[1]" />
    <xsl:variable name="json">
      <map>
        <string key="operation">CREATE</string>
        <string key="order_identifier">
          <xsl:value-of select="normalize-space($firstDoc/ns0:No)" />
        </string>
        <map key="import_configuration">
          <string key="code">api</string>
        </map>
        <map key="customer">
          <string key="name">
            <xsl:value-of select="normalize-space($firstDoc/ns0:Customer/ns0:Name)" />
          </string>
        </map>
        <map key="transport_service">
          <string key="name">Transport</string>
        </map>
        <array key="consignments">
          <xsl:for-each select="ns0:TripLines/ns0:TripLine">
            <xsl:sort select="number(ns0:LoadOrder)" data-type="number" order="descending" />
            <xsl:call-template name="emit-forward-consignment" />
            <xsl:if test="ns0:Documents/ns0:Document[1]/ns0:ShippingAgentCode = ('0000000030', '0000000331', '0000000332', '0000070861', '0000070864', '0000070865', '0000070866', '0000070868', '0000070869')">
              <xsl:call-template name="emit-return-consignment" />
            </xsl:if>
          </xsl:for-each>
        </array>
        <map key="pricing" />
      </map>
    </xsl:variable>
    <xsl:value-of select="xml-to-json($json)" />
  </xsl:template>

  <xsl:template name="emit-forward-consignment">
    <xsl:variable name="doc" select="ns0:Documents/ns0:Document[1]" />
    <xsl:variable name="pickup" select="$doc/ns0:SenderAddress" />
    <xsl:variable name="delivery" select="$doc/ns0:ShipToAddress" />
    <xsl:variable name="lineCount" select="count($doc/ns0:DocumentLines/ns0:DocumentLine)" />
    <xsl:variable name="expectedQty" select="normalize-space($doc/ns0:ExpectedShipmentCarrierQty)" />
    <xsl:variable name="isStackable" select="count($doc/ns0:DocumentLines/ns0:DocumentLine[starts-with(normalize-space(ns0:CarrierTypeCode), '2DUSS')]) &gt; 0" />

    <map>
      <map key="pickup_stop">
        <string key="activity_label">PICKUP</string>
        <string key="reference_number">
          <xsl:value-of select="normalize-space(../../ns0:No)" />
        </string>
        <map key="time_window">
          <string key="name">Afspraak</string>
          <string key="start_time">
            <xsl:value-of select="normalize-space($doc/ns0:PlannedStartTime)" />
          </string>
          <string key="end_time">
            <xsl:value-of select="normalize-space($doc/ns0:PlannedStartTime)" />
          </string>
          <boolean key="use_location_opening_hours">false</boolean>
        </map>
        <string key="date">
          <xsl:value-of select="normalize-space($doc/ns0:PlannedStartDate)" />
        </string>
        <xsl:call-template name="emit-location">
          <xsl:with-param name="node" select="$pickup" />
          <xsl:with-param name="key" select="'location'" />
        </xsl:call-template>
      </map>
      <map key="delivery_stop">
        <string key="activity_label">DELIVERY</string>
        <xsl:if test="normalize-space($doc/ns0:ShippingAgentName) != '' or $doc/ns0:Comments/ns0:Comment[ns0:Code = 'LOSINSTRUCTIE']">
          <string key="note">
            <xsl:value-of select="normalize-space($doc/ns0:ShippingAgentName)" />
            <xsl:for-each select="$doc/ns0:Comments/ns0:Comment[ns0:Code = 'LOSINSTRUCTIE']">
              <xsl:if test="position() != 1 or normalize-space($doc/ns0:ShippingAgentName) != ''">
                <xsl:text> / </xsl:text>
              </xsl:if>
              <xsl:value-of select="normalize-space(ns0:Comment)" />
            </xsl:for-each>
          </string>
        </xsl:if>
        <string key="reference_number">
          <xsl:choose>
            <xsl:when test="normalize-space($doc/ns0:ExternalDocumentNo) != '' and normalize-space($doc/ns0:ExternalReference) != ''">
              <xsl:value-of select="concat(normalize-space($doc/ns0:ExternalDocumentNo), ' / ', normalize-space($doc/ns0:ExternalReference))" />
            </xsl:when>
            <xsl:when test="normalize-space($doc/ns0:ExternalDocumentNo) != ''">
              <xsl:value-of select="normalize-space($doc/ns0:ExternalDocumentNo)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space($doc/ns0:ExternalReference)" />
            </xsl:otherwise>
          </xsl:choose>
        </string>
        <map key="time_window">
          <string key="start_time">
            <xsl:value-of select="normalize-space($doc/ns0:PlannedStartTime)" />
          </string>
          <boolean key="use_location_opening_hours">false</boolean>
        </map>
        <string key="date">
          <xsl:value-of select="normalize-space($doc/ns0:DeliveryDate)" />
        </string>
        <xsl:call-template name="emit-location">
          <xsl:with-param name="node" select="$delivery" />
          <xsl:with-param name="key" select="'location'" />
        </xsl:call-template>
      </map>
      <array key="goods">
        <map>
          <number key="quantity">
            <xsl:value-of select="$lineCount" />
          </number>
          <xsl:if test="$expectedQty != ''">
            <number key="total_pallet_spaces">
              <xsl:value-of select="$expectedQty" />
            </number>
          </xsl:if>
          <number key="unit_pallet_spaces">1.0</number>
          <xsl:call-template name="emit-packaging-type">
            <xsl:with-param name="isStackable" select="$isStackable" />
            <xsl:with-param name="key" select="'packaging_type'" />
          </xsl:call-template>
        </map>
      </array>
    </map>
  </xsl:template>

  <xsl:template name="emit-return-consignment">
    <xsl:variable name="doc" select="ns0:Documents/ns0:Document[1]" />
    <xsl:variable name="pickup" select="$doc/ns0:ShipToAddress" />
    <xsl:variable name="delivery" select="preceding-sibling::ns0:TripLine[1]/ns0:Documents/ns0:Document[1]/ns0:ShipToAddress | ns0:Documents/ns0:Document[1]/ns0:SenderAddress[not(../../../preceding-sibling::ns0:TripLine)]" />
    <xsl:variable name="returnQty" select="normalize-space($doc/ns0:ExpectedShipmentCarrierQty)" />
    <xsl:variable name="isStackable" select="count($doc/ns0:DocumentLines/ns0:DocumentLine[starts-with(normalize-space(ns0:CarrierTypeCode), '2DUSS')]) &gt; 0" />

    <map>
      <map key="pickup_stop">
        <string key="activity_label">PICKUP</string>
        <string key="reference_number">emballage retour</string>
        <string key="date">
          <xsl:choose>
            <xsl:when test="normalize-space($doc/ns0:DeliveryDate) != ''">
              <xsl:value-of select="normalize-space($doc/ns0:DeliveryDate)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space($doc/ns0:PlannedStartDate)" />
            </xsl:otherwise>
          </xsl:choose>
        </string>
        <xsl:call-template name="emit-location">
          <xsl:with-param name="node" select="$pickup" />
          <xsl:with-param name="key" select="'location'" />
        </xsl:call-template>
      </map>
      <map key="delivery_stop">
        <string key="activity_label">DELIVERY</string>
        <string key="reference_number">emballage retour</string>
        <string key="date">
          <xsl:choose>
            <xsl:when test="normalize-space($doc/ns0:DeliveryDate) != ''">
              <xsl:value-of select="normalize-space($doc/ns0:DeliveryDate)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space($doc/ns0:PlannedStartDate)" />
            </xsl:otherwise>
          </xsl:choose>
        </string>
        <xsl:call-template name="emit-location">
          <xsl:with-param name="node" select="$delivery[1]" />
          <xsl:with-param name="key" select="'location'" />
        </xsl:call-template>
      </map>
      <array key="goods">
        <map>
          <xsl:if test="$isStackable">
            <string key="description">emballage</string>
          </xsl:if>
          <number key="quantity">
            <xsl:choose>
              <xsl:when test="$returnQty != ''">
                <xsl:value-of select="$returnQty" />
              </xsl:when>
              <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
          </number>
          <xsl:call-template name="emit-packaging-type">
            <xsl:with-param name="isStackable" select="$isStackable" />
            <xsl:with-param name="key" select="'packaging_type'" />
          </xsl:call-template>
        </map>
      </array>
    </map>
  </xsl:template>

  <xsl:template name="emit-location">
    <xsl:param name="node" />
    <xsl:param name="key" />
    <map key="{$key}">
      <string key="address">
        <xsl:value-of select="normalize-space($node/ns0:Address)" />
      </string>
      <xsl:if test="normalize-space($node/ns0:Name2) != ''">
        <string key="address_second_line">
          <xsl:value-of select="normalize-space($node/ns0:Name2)" />
        </string>
      </xsl:if>
      <string key="city">
        <xsl:call-template name="to-title-case">
          <xsl:with-param name="text" select="normalize-space($node/ns0:City)" />
        </xsl:call-template>
      </string>
      <string key="country">
        <xsl:value-of select="normalize-space($node/ns0:CountryRegionCode)" />
      </string>
      <string key="postal_code">
        <xsl:value-of select="normalize-space($node/ns0:PostCode)" />
      </string>
      <string key="name">
        <xsl:call-template name="to-title-case">
          <xsl:with-param name="text" select="normalize-space($node/ns0:Name)" />
        </xsl:call-template>
      </string>
    </map>
  </xsl:template>

  <xsl:template name="emit-packaging-type">
    <xsl:param name="isStackable" />
    <xsl:param name="key" />
    <map key="{$key}">
      <xsl:choose>
        <xsl:when test="$isStackable">
          <string key="name">Pallets Stackable</string>
          <string key="export_alias">urn:x-qargo:alias:CARGO_PACKAGING:3e0ad7ef-c1bb-4baa-9d1b-55052c5cfe19</string>
          <map key="packaging_size">
            <string key="name">Pallet</string>
          </map>
        </xsl:when>
        <xsl:otherwise>
          <string key="name">Pallets</string>
          <string key="export_alias">urn:x-qargo:alias:CARGO_PACKAGING:5af9b392-ebd5-4652-b74a-e7bb95514967</string>
          <map key="packaging_size">
            <string key="name">Pallet</string>
            <number key="pallet_spaces">1.0</number>
          </map>
        </xsl:otherwise>
      </xsl:choose>
    </map>
  </xsl:template>

  <xsl:template name="to-title-case">
    <xsl:param name="text" />
    <xsl:variable name="s" select="normalize-space($text)" />
    <xsl:choose>
      <xsl:when test="$s = ''" />
      <xsl:otherwise>
        <xsl:value-of select="translate(substring($s, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
        <xsl:value-of select="translate(substring($s, 2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>