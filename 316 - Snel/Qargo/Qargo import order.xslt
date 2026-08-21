<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ns0="www.boltrics.nl/sendtripqargo:v1.00">
  <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" />
  
  <xsl:template match="/">
    <xsl:apply-templates select="ns0:Message/ns0:Trips/ns0:Trip[1]" />
  </xsl:template>
  
  <xsl:template match="ns0:Trip">
    <xsl:variable name="firstDoc" select="ns0:TripLines/ns0:TripLine[1]/ns0:Documents/ns0:Document[1]" />
    
    <xsl:text>{</xsl:text>
    <xsl:text>"operation":"CREATE",</xsl:text>
    
    <!-- Mapping uncertain: output sample uses a W* identifier not found in this XML, so Document No is used as practical fallback. -->
    <xsl:text>"order_identifier":"</xsl:text>
    <xsl:call-template name="escape-json">
      <xsl:with-param name="text" select="normalize-space($firstDoc/ns0:No)" />
    </xsl:call-template>
    <xsl:text>",</xsl:text>
    <xsl:text>"import_configuration":{"code":"api"},</xsl:text>
    <xsl:text>"customer":{"name":"</xsl:text>
    <xsl:call-template name="escape-json">
      <xsl:with-param name="text" select="normalize-space($firstDoc/ns0:Customer/ns0:Name)" />
    </xsl:call-template>
    <xsl:text>"},</xsl:text>
    <xsl:text>"transport_service":{"name":"Transport"},</xsl:text>
    
    <xsl:text>"consignments":[</xsl:text>
    <xsl:for-each select="ns0:TripLines/ns0:TripLine">
      <xsl:sort select="number(ns0:LoadOrder)" data-type="number" order="descending" />
      <xsl:call-template name="emit-forward-consignment" />

      <xsl:if test="ns0:Documents/ns0:Document[1]/ns0:ShippingAgentCode = '0000000030' or ns0:Documents/ns0:Document[1]/ns0:ShippingAgentCode = '0000000331' or ns0:Documents/ns0:Document[1]/ns0:ShippingAgentCode = '0000000332' or ns0:Documents/ns0:Document[1]/ns0:ShippingAgentCode = '0000070861' or ns0:Documents/ns0:Document[1]/ns0:ShippingAgentCode = '0000070864' or ns0:Documents/ns0:Document[1]/ns0:ShippingAgentCode = '0000070865' or ns0:Documents/ns0:Document[1]/ns0:ShippingAgentCode = '0000070866' or ns0:Documents/ns0:Document[1]/ns0:ShippingAgentCode = '0000070868' or ns0:Documents/ns0:Document[1]/ns0:ShippingAgentCode = '0000070869'">
        <xsl:text>,</xsl:text>
        <xsl:call-template name="emit-return-consignment" />
      </xsl:if>
      
      <xsl:if test="position() != last()">
        <xsl:text>,</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>],</xsl:text>
    <xsl:text>"pricing":{}</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <xsl:template name="emit-forward-consignment">
    <xsl:variable name="doc" select="ns0:Documents/ns0:Document[1]" />
    <xsl:variable name="pickup" select="$doc/ns0:SenderAddress" />
    <xsl:variable name="delivery" select="$doc/ns0:ShipToAddress" />
    <xsl:variable name="lineCount" select="count($doc/ns0:DocumentLines/ns0:DocumentLine)" />
    <xsl:variable name="expectedQty" select="normalize-space($doc/ns0:ExpectedShipmentCarrierQty)" />
    <xsl:variable name="isStackable" select="count($doc/ns0:DocumentLines/ns0:DocumentLine[starts-with(normalize-space(ns0:CarrierTypeCode), '2DUSS')]) &gt; 0" />
    
    <xsl:text>{</xsl:text>
    <xsl:text>"pickup_stop":{</xsl:text>
    <xsl:text>"activity_label":"PICKUP",</xsl:text>
    <xsl:text>"reference_number":"</xsl:text>
    <xsl:call-template name="escape-json">
      <xsl:with-param name="text" select="normalize-space(../../ns0:No)" />
    </xsl:call-template>
    <xsl:text>",</xsl:text>
    
    <xsl:text>"time_window":{</xsl:text>
    <xsl:text>"name":"Afspraak",</xsl:text>
    <xsl:text>"start_time":"</xsl:text>
    <xsl:value-of select="normalize-space($doc/ns0:PlannedStartTime)" />
    <xsl:text>","end_time":"</xsl:text>
    <xsl:value-of select="normalize-space($doc/ns0:PlannedStartTime)" />
    <xsl:text>","use_location_opening_hours":false},</xsl:text>
    
    <xsl:text>"date":"</xsl:text>
    <xsl:value-of select="normalize-space($doc/ns0:PlannedStartDate)" />
    <xsl:text>",</xsl:text>
    
    <xsl:text>"location":</xsl:text>
    <xsl:call-template name="emit-location">
      <xsl:with-param name="node" select="$pickup" />
      <xsl:with-param name="fallbackId" select="normalize-space($pickup/ns0:No)" />
    </xsl:call-template>
    <xsl:text>},</xsl:text>
    
    <xsl:text>"delivery_stop":{</xsl:text>
    <xsl:text>"activity_label":"DELIVERY",</xsl:text>
    <xsl:if test="normalize-space($doc/ns0:ShippingAgentName) != ''">
      <xsl:text>"note":"</xsl:text>
      <xsl:call-template name="escape-json">
        <xsl:with-param name="text" select="normalize-space($doc/ns0:ShippingAgentName)" />
      </xsl:call-template>
      <xsl:text>",</xsl:text>
    </xsl:if>
    <xsl:text>"reference_number":"</xsl:text>
    <xsl:call-template name="escape-json">
      <xsl:with-param name="text">
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
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>",</xsl:text>
    
    <xsl:text>"time_window":{</xsl:text>
    <xsl:text>"start_time":"</xsl:text>
    <xsl:value-of select="normalize-space($doc/ns0:PlannedStartTime)" />
    <xsl:text>","use_location_opening_hours":false},</xsl:text>
    
    <xsl:text>"date":"</xsl:text>
    <xsl:value-of select="normalize-space($doc/ns0:DeliveryDate)" />
    <xsl:text>",</xsl:text>
    
    <xsl:text>"location":</xsl:text>
    <xsl:call-template name="emit-location">
      <xsl:with-param name="node" select="$delivery" />
      <xsl:with-param name="fallbackId" select="normalize-space($delivery/ns0:No)" />
    </xsl:call-template>
    <xsl:text>},</xsl:text>
    
    <xsl:text>"goods":[{</xsl:text>
    <xsl:text>"quantity":</xsl:text>
    <xsl:value-of select="$lineCount" />
    <xsl:if test="$expectedQty != ''">
      <xsl:text>,"total_pallet_spaces":</xsl:text>
      <xsl:value-of select="$expectedQty" />
    </xsl:if>
    <xsl:text>,"unit_pallet_spaces":1.0,</xsl:text>
    <xsl:text>"packaging_type":</xsl:text>
    <xsl:call-template name="emit-packaging-type">
      <xsl:with-param name="isStackable" select="$isStackable" />
    </xsl:call-template>
    <xsl:text>}]</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <xsl:template name="emit-return-consignment">
    <xsl:variable name="doc" select="ns0:Documents/ns0:Document[1]" />
    <xsl:variable name="pickup" select="$doc/ns0:ShipToAddress" />
    <xsl:variable name="delivery" select="$doc/ns0:SenderAddress" />
    <xsl:variable name="returnQty" select="normalize-space($doc/ns0:ExpectedShipmentCarrierQty)" />
    <xsl:variable name="isStackable" select="count($doc/ns0:DocumentLines/ns0:DocumentLine[starts-with(normalize-space(ns0:CarrierTypeCode), '2DUSS')]) &gt; 0" />
    
    <xsl:text>{</xsl:text>
    <xsl:text>"pickup_stop":{</xsl:text>
    <xsl:text>"activity_label":"PICKUP",</xsl:text>
    <xsl:text>"reference_number":"emballage retour",</xsl:text>
    <xsl:text>"date":"</xsl:text>
    <xsl:choose>
      <xsl:when test="normalize-space($doc/ns0:DeliveryDate) != ''">
        <xsl:value-of select="normalize-space($doc/ns0:DeliveryDate)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space($doc/ns0:PlannedStartDate)" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>",</xsl:text>
    <xsl:text>"location":</xsl:text>
    <xsl:call-template name="emit-location">
      <xsl:with-param name="node" select="$pickup" />
      <xsl:with-param name="fallbackId" select="normalize-space($pickup/ns0:No)" />
    </xsl:call-template>
    <xsl:text>},</xsl:text>
    
    <xsl:text>"delivery_stop":{</xsl:text>
    <xsl:text>"activity_label":"DELIVERY",</xsl:text>
    <xsl:text>"reference_number":"emballage retour",</xsl:text>
    <xsl:text>"date":"</xsl:text>
    <xsl:choose>
      <xsl:when test="normalize-space($doc/ns0:DeliveryDate) != ''">
        <xsl:value-of select="normalize-space($doc/ns0:DeliveryDate)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space($doc/ns0:PlannedStartDate)" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>",</xsl:text>
    <xsl:text>"location":</xsl:text>
    <xsl:call-template name="emit-location">
      <xsl:with-param name="node" select="$delivery" />
      <xsl:with-param name="fallbackId" select="normalize-space($delivery/ns0:No)" />
    </xsl:call-template>
    <xsl:text>},</xsl:text>
    
    <xsl:text>"goods":[{</xsl:text>
    <xsl:if test="$isStackable">
      <xsl:text>"description":"emballage",</xsl:text>
    </xsl:if>
    <xsl:if test="$returnQty != ''">
      <xsl:text>"quantity":</xsl:text>
      <xsl:value-of select="$returnQty" />
      <xsl:text>,</xsl:text>
    </xsl:if>
    <xsl:text>"packaging_type":</xsl:text>
    <xsl:call-template name="emit-packaging-type">
      <xsl:with-param name="isStackable" select="$isStackable" />
    </xsl:call-template>
    <xsl:text>}]</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <xsl:template name="emit-location">
    <xsl:param name="node" />
    <xsl:param name="fallbackId" />
    <xsl:text>{</xsl:text>
    <xsl:text>"address":"</xsl:text>
    <xsl:call-template name="escape-json">
      <xsl:with-param name="text" select="normalize-space($node/ns0:Address)" />
    </xsl:call-template>
    <xsl:text>",</xsl:text>
    <xsl:if test="normalize-space($node/ns0:Name2) != ''">
      <xsl:text>"address_second_line":"</xsl:text>
      <xsl:call-template name="escape-json">
        <xsl:with-param name="text" select="normalize-space($node/ns0:Name2)" />
      </xsl:call-template>
      <xsl:text>",</xsl:text>
    </xsl:if>
    <xsl:text>"city":"</xsl:text>
    <xsl:call-template name="to-title-case">
      <xsl:with-param name="text" select="normalize-space($node/ns0:City)" />
    </xsl:call-template>
    <xsl:text>",</xsl:text>
    <xsl:text>"country":"</xsl:text>
    <xsl:call-template name="escape-json">
      <xsl:with-param name="text" select="normalize-space($node/ns0:CountryRegionCode)" />
    </xsl:call-template>
    <xsl:text>",</xsl:text>
    <xsl:text>"postal_code":"</xsl:text>
    <xsl:call-template name="escape-json">
      <xsl:with-param name="text" select="normalize-space($node/ns0:PostCode)" />
    </xsl:call-template>
    <xsl:text>",</xsl:text>
    <xsl:text>"name":"</xsl:text>
    <xsl:call-template name="to-title-case">
      <xsl:with-param name="text" select="normalize-space($node/ns0:Name)" />
    </xsl:call-template>
    <xsl:text>"}</xsl:text>
    
    <!-- Mapping uncertain: target examples include UUID + geocoordinates that are not present in source XML. -->
    <!-- <xsl:text>"id":"</xsl:text>
         <xsl:choose>
         <xsl:when test="normalize-space($node/ns0:No) != ''">
         <xsl:call-template name="escape-json">
         <xsl:with-param name="text" select="normalize-space($node/ns0:No)" />
         </xsl:call-template>
         </xsl:when>
         <xsl:when test="normalize-space($node/ns0:ExternalNo) != ''">
         <xsl:call-template name="escape-json">
         <xsl:with-param name="text" select="normalize-space($node/ns0:ExternalNo)" />
         </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
         <xsl:call-template name="escape-json">
         <xsl:with-param name="text" select="$fallbackId" />
         </xsl:call-template>
         </xsl:otherwise>
         </xsl:choose> -->
    <!-- <xsl:text>"}</xsl:text> -->
  </xsl:template>
  
  <xsl:template name="emit-packaging-type">
    <xsl:param name="isStackable" />
    <xsl:choose>
      <xsl:when test="$isStackable">
        <xsl:text>{"name":"Pallets Stackable","export_alias":"urn:x-qargo:alias:CARGO_PACKAGING:3e0ad7ef-c1bb-4baa-9d1b-55052c5cfe19","packaging_size":{"name":"Pallet"}}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>{"name":"Pallets","export_alias":"urn:x-qargo:alias:CARGO_PACKAGING:5af9b392-ebd5-4652-b74a-e7bb95514967","packaging_size":{"name":"Pallet","pallet_spaces":1.0}}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
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
  
  <xsl:template name="escape-json">
    <xsl:param name="text" />
    <xsl:variable name="escapedBackslash">
      <xsl:call-template name="replace-string">
        <xsl:with-param name="text" select="string($text)" />
        <xsl:with-param name="search" select="'\'" />
        <xsl:with-param name="replace" select="'\\'" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="text" select="string($escapedBackslash)" />
      <xsl:with-param name="search" select="'&quot;'" />
      <xsl:with-param name="replace" select="'\&quot;'" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="replace-string">
    <xsl:param name="text" />
    <xsl:param name="search" />
    <xsl:param name="replace" />
    <xsl:choose>
      <xsl:when test="contains($text, $search)">
        <xsl:value-of select="substring-before($text, $search)" />
        <xsl:value-of select="$replace" />
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="substring-after($text, $search)" />
          <xsl:with-param name="search" select="$search" />
          <xsl:with-param name="replace" select="$replace" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
