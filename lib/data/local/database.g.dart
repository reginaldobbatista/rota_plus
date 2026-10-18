// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LocalRideEvaluationsTable extends LocalRideEvaluations
    with TableInfo<$LocalRideEvaluationsTable, LocalRide> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalRideEvaluationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RidePlatform, String> platform =
      GeneratedColumn<String>(
        'platform',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RidePlatform>(
        $LocalRideEvaluationsTable.$converterplatform,
      );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> fare =
      GeneratedColumn<String>(
        'fare',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalRideEvaluationsTable.$converterfare);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> pickupKm =
      GeneratedColumn<String>(
        'pickup_km',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalRideEvaluationsTable.$converterpickupKm);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> tripKm =
      GeneratedColumn<String>(
        'trip_km',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalRideEvaluationsTable.$convertertripKm);
  static const VerificationMeta _pickupMinutesMeta = const VerificationMeta(
    'pickupMinutes',
  );
  @override
  late final GeneratedColumn<double> pickupMinutes = GeneratedColumn<double>(
    'pickup_minutes',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tripMinutesMeta = const VerificationMeta(
    'tripMinutes',
  );
  @override
  late final GeneratedColumn<double> tripMinutes = GeneratedColumn<double>(
    'trip_minutes',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _passengerRatingMeta = const VerificationMeta(
    'passengerRating',
  );
  @override
  late final GeneratedColumn<double> passengerRating = GeneratedColumn<double>(
    'passenger_rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pickupRegionMeta = const VerificationMeta(
    'pickupRegion',
  );
  @override
  late final GeneratedColumn<String> pickupRegion = GeneratedColumn<String>(
    'pickup_region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String>
  surgeMultiplier =
      GeneratedColumn<String>(
        'surge_multiplier',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>(
        $LocalRideEvaluationsTable.$convertersurgeMultipliern,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> rsPerKm =
      GeneratedColumn<String>(
        'rs_per_km',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalRideEvaluationsTable.$converterrsPerKm);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> rsPerHour =
      GeneratedColumn<String>(
        'rs_per_hour',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalRideEvaluationsTable.$converterrsPerHour);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> costPerKmUsed =
      GeneratedColumn<String>(
        'cost_per_km_used',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>(
        $LocalRideEvaluationsTable.$convertercostPerKmUsed,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> operatingCost =
      GeneratedColumn<String>(
        'operating_cost',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>(
        $LocalRideEvaluationsTable.$converteroperatingCost,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> realProfit =
      GeneratedColumn<String>(
        'real_profit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalRideEvaluationsTable.$converterrealProfit);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> marginPercent =
      GeneratedColumn<String>(
        'margin_percent',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>(
        $LocalRideEvaluationsTable.$convertermarginPercentn,
      );
  @override
  late final GeneratedColumnWithTypeConverter<RideVerdict, String> verdict =
      GeneratedColumn<String>(
        'verdict',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RideVerdict>(
        $LocalRideEvaluationsTable.$converterverdict,
      );
  @override
  late final GeneratedColumnWithTypeConverter<RideOutcome, String> outcome =
      GeneratedColumn<String>(
        'outcome',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RideOutcome>(
        $LocalRideEvaluationsTable.$converteroutcome,
      );
  static const VerificationMeta _workSessionClientIdMeta =
      const VerificationMeta('workSessionClientId');
  @override
  late final GeneratedColumn<String> workSessionClientId =
      GeneratedColumn<String>(
        'work_session_client_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    platform,
    occurredAt,
    fare,
    pickupKm,
    tripKm,
    pickupMinutes,
    tripMinutes,
    passengerRating,
    pickupRegion,
    surgeMultiplier,
    rsPerKm,
    rsPerHour,
    costPerKmUsed,
    operatingCost,
    realProfit,
    marginPercent,
    verdict,
    outcome,
    workSessionClientId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_ride_evaluations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalRide> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('pickup_minutes')) {
      context.handle(
        _pickupMinutesMeta,
        pickupMinutes.isAcceptableOrUnknown(
          data['pickup_minutes']!,
          _pickupMinutesMeta,
        ),
      );
    }
    if (data.containsKey('trip_minutes')) {
      context.handle(
        _tripMinutesMeta,
        tripMinutes.isAcceptableOrUnknown(
          data['trip_minutes']!,
          _tripMinutesMeta,
        ),
      );
    }
    if (data.containsKey('passenger_rating')) {
      context.handle(
        _passengerRatingMeta,
        passengerRating.isAcceptableOrUnknown(
          data['passenger_rating']!,
          _passengerRatingMeta,
        ),
      );
    }
    if (data.containsKey('pickup_region')) {
      context.handle(
        _pickupRegionMeta,
        pickupRegion.isAcceptableOrUnknown(
          data['pickup_region']!,
          _pickupRegionMeta,
        ),
      );
    }
    if (data.containsKey('work_session_client_id')) {
      context.handle(
        _workSessionClientIdMeta,
        workSessionClientId.isAcceptableOrUnknown(
          data['work_session_client_id']!,
          _workSessionClientIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalRide map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalRide(
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      platform: $LocalRideEvaluationsTable.$converterplatform.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}platform'],
        )!,
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      fare: $LocalRideEvaluationsTable.$converterfare.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fare'],
        )!,
      ),
      pickupKm: $LocalRideEvaluationsTable.$converterpickupKm.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}pickup_km'],
        )!,
      ),
      tripKm: $LocalRideEvaluationsTable.$convertertripKm.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}trip_km'],
        )!,
      ),
      pickupMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pickup_minutes'],
      )!,
      tripMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}trip_minutes'],
      )!,
      passengerRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}passenger_rating'],
      ),
      pickupRegion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pickup_region'],
      ),
      surgeMultiplier: $LocalRideEvaluationsTable.$convertersurgeMultipliern
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}surge_multiplier'],
            ),
          ),
      rsPerKm: $LocalRideEvaluationsTable.$converterrsPerKm.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rs_per_km'],
        )!,
      ),
      rsPerHour: $LocalRideEvaluationsTable.$converterrsPerHour.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rs_per_hour'],
        )!,
      ),
      costPerKmUsed: $LocalRideEvaluationsTable.$convertercostPerKmUsed.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cost_per_km_used'],
        )!,
      ),
      operatingCost: $LocalRideEvaluationsTable.$converteroperatingCost.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}operating_cost'],
        )!,
      ),
      realProfit: $LocalRideEvaluationsTable.$converterrealProfit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}real_profit'],
        )!,
      ),
      marginPercent: $LocalRideEvaluationsTable.$convertermarginPercentn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}margin_percent'],
            ),
          ),
      verdict: $LocalRideEvaluationsTable.$converterverdict.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}verdict'],
        )!,
      ),
      outcome: $LocalRideEvaluationsTable.$converteroutcome.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}outcome'],
        )!,
      ),
      workSessionClientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_session_client_id'],
      ),
    );
  }

  @override
  $LocalRideEvaluationsTable createAlias(String alias) {
    return $LocalRideEvaluationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RidePlatform, String, String> $converterplatform =
      const EnumNameConverter<RidePlatform>(RidePlatform.values);
  static TypeConverter<Decimal, String> $converterfare =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterpickupKm =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $convertertripKm =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $convertersurgeMultiplier =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $convertersurgeMultipliern =
      NullAwareTypeConverter.wrap($convertersurgeMultiplier);
  static TypeConverter<Decimal, String> $converterrsPerKm =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterrsPerHour =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $convertercostPerKmUsed =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converteroperatingCost =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterrealProfit =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $convertermarginPercent =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $convertermarginPercentn =
      NullAwareTypeConverter.wrap($convertermarginPercent);
  static JsonTypeConverter2<RideVerdict, String, String> $converterverdict =
      const EnumNameConverter<RideVerdict>(RideVerdict.values);
  static JsonTypeConverter2<RideOutcome, String, String> $converteroutcome =
      const EnumNameConverter<RideOutcome>(RideOutcome.values);
}

class LocalRide extends DataClass implements Insertable<LocalRide> {
  /// UUID gerado no dispositivo.
  final String clientId;

  /// Plataforma de origem da oferta.
  final RidePlatform platform;

  /// Momento da avaliação.
  final DateTime occurredAt;

  /// Valor oferecido pela corrida.
  final Decimal fare;

  /// Distância até o passageiro, em km.
  final Decimal pickupKm;

  /// Distância da corrida, em km.
  final Decimal tripKm;

  /// Tempo até o passageiro, em minutos.
  final double pickupMinutes;

  /// Tempo da corrida, em minutos.
  final double tripMinutes;

  /// Nota do passageiro, quando informada.
  final double? passengerRating;

  /// Nome do bairro ou região de embarque.
  final String? pickupRegion;

  /// Multiplicador de tarifa dinâmica, quando informado.
  final Decimal? surgeMultiplier;

  /// Receita por quilômetro.
  final Decimal rsPerKm;

  /// Receita por hora.
  final Decimal rsPerHour;

  /// Custo por km usado na avaliação.
  final Decimal costPerKmUsed;

  /// Custo operacional estimado.
  final Decimal operatingCost;

  /// Lucro real.
  final Decimal realProfit;

  /// Margem sobre a tarifa, em percentual.
  final Decimal? marginPercent;

  /// Veredicto do semáforo.
  final RideVerdict verdict;

  /// Desfecho: o motorista aceitou, recusou, expirou.
  final RideOutcome outcome;

  /// Sessão de trabalho à qual a corrida pertence.
  final String? workSessionClientId;
  const LocalRide({
    required this.clientId,
    required this.platform,
    required this.occurredAt,
    required this.fare,
    required this.pickupKm,
    required this.tripKm,
    required this.pickupMinutes,
    required this.tripMinutes,
    this.passengerRating,
    this.pickupRegion,
    this.surgeMultiplier,
    required this.rsPerKm,
    required this.rsPerHour,
    required this.costPerKmUsed,
    required this.operatingCost,
    required this.realProfit,
    this.marginPercent,
    required this.verdict,
    required this.outcome,
    this.workSessionClientId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    {
      map['platform'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterplatform.toSql(platform),
      );
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    {
      map['fare'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterfare.toSql(fare),
      );
    }
    {
      map['pickup_km'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterpickupKm.toSql(pickupKm),
      );
    }
    {
      map['trip_km'] = Variable<String>(
        $LocalRideEvaluationsTable.$convertertripKm.toSql(tripKm),
      );
    }
    map['pickup_minutes'] = Variable<double>(pickupMinutes);
    map['trip_minutes'] = Variable<double>(tripMinutes);
    if (!nullToAbsent || passengerRating != null) {
      map['passenger_rating'] = Variable<double>(passengerRating);
    }
    if (!nullToAbsent || pickupRegion != null) {
      map['pickup_region'] = Variable<String>(pickupRegion);
    }
    if (!nullToAbsent || surgeMultiplier != null) {
      map['surge_multiplier'] = Variable<String>(
        $LocalRideEvaluationsTable.$convertersurgeMultipliern.toSql(
          surgeMultiplier,
        ),
      );
    }
    {
      map['rs_per_km'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterrsPerKm.toSql(rsPerKm),
      );
    }
    {
      map['rs_per_hour'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterrsPerHour.toSql(rsPerHour),
      );
    }
    {
      map['cost_per_km_used'] = Variable<String>(
        $LocalRideEvaluationsTable.$convertercostPerKmUsed.toSql(costPerKmUsed),
      );
    }
    {
      map['operating_cost'] = Variable<String>(
        $LocalRideEvaluationsTable.$converteroperatingCost.toSql(operatingCost),
      );
    }
    {
      map['real_profit'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterrealProfit.toSql(realProfit),
      );
    }
    if (!nullToAbsent || marginPercent != null) {
      map['margin_percent'] = Variable<String>(
        $LocalRideEvaluationsTable.$convertermarginPercentn.toSql(
          marginPercent,
        ),
      );
    }
    {
      map['verdict'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterverdict.toSql(verdict),
      );
    }
    {
      map['outcome'] = Variable<String>(
        $LocalRideEvaluationsTable.$converteroutcome.toSql(outcome),
      );
    }
    if (!nullToAbsent || workSessionClientId != null) {
      map['work_session_client_id'] = Variable<String>(workSessionClientId);
    }
    return map;
  }

  LocalRideEvaluationsCompanion toCompanion(bool nullToAbsent) {
    return LocalRideEvaluationsCompanion(
      clientId: Value(clientId),
      platform: Value(platform),
      occurredAt: Value(occurredAt),
      fare: Value(fare),
      pickupKm: Value(pickupKm),
      tripKm: Value(tripKm),
      pickupMinutes: Value(pickupMinutes),
      tripMinutes: Value(tripMinutes),
      passengerRating: passengerRating == null && nullToAbsent
          ? const Value.absent()
          : Value(passengerRating),
      pickupRegion: pickupRegion == null && nullToAbsent
          ? const Value.absent()
          : Value(pickupRegion),
      surgeMultiplier: surgeMultiplier == null && nullToAbsent
          ? const Value.absent()
          : Value(surgeMultiplier),
      rsPerKm: Value(rsPerKm),
      rsPerHour: Value(rsPerHour),
      costPerKmUsed: Value(costPerKmUsed),
      operatingCost: Value(operatingCost),
      realProfit: Value(realProfit),
      marginPercent: marginPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(marginPercent),
      verdict: Value(verdict),
      outcome: Value(outcome),
      workSessionClientId: workSessionClientId == null && nullToAbsent
          ? const Value.absent()
          : Value(workSessionClientId),
    );
  }

  factory LocalRide.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalRide(
      clientId: serializer.fromJson<String>(json['clientId']),
      platform: $LocalRideEvaluationsTable.$converterplatform.fromJson(
        serializer.fromJson<String>(json['platform']),
      ),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      fare: serializer.fromJson<Decimal>(json['fare']),
      pickupKm: serializer.fromJson<Decimal>(json['pickupKm']),
      tripKm: serializer.fromJson<Decimal>(json['tripKm']),
      pickupMinutes: serializer.fromJson<double>(json['pickupMinutes']),
      tripMinutes: serializer.fromJson<double>(json['tripMinutes']),
      passengerRating: serializer.fromJson<double?>(json['passengerRating']),
      pickupRegion: serializer.fromJson<String?>(json['pickupRegion']),
      surgeMultiplier: serializer.fromJson<Decimal?>(json['surgeMultiplier']),
      rsPerKm: serializer.fromJson<Decimal>(json['rsPerKm']),
      rsPerHour: serializer.fromJson<Decimal>(json['rsPerHour']),
      costPerKmUsed: serializer.fromJson<Decimal>(json['costPerKmUsed']),
      operatingCost: serializer.fromJson<Decimal>(json['operatingCost']),
      realProfit: serializer.fromJson<Decimal>(json['realProfit']),
      marginPercent: serializer.fromJson<Decimal?>(json['marginPercent']),
      verdict: $LocalRideEvaluationsTable.$converterverdict.fromJson(
        serializer.fromJson<String>(json['verdict']),
      ),
      outcome: $LocalRideEvaluationsTable.$converteroutcome.fromJson(
        serializer.fromJson<String>(json['outcome']),
      ),
      workSessionClientId: serializer.fromJson<String?>(
        json['workSessionClientId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'platform': serializer.toJson<String>(
        $LocalRideEvaluationsTable.$converterplatform.toJson(platform),
      ),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'fare': serializer.toJson<Decimal>(fare),
      'pickupKm': serializer.toJson<Decimal>(pickupKm),
      'tripKm': serializer.toJson<Decimal>(tripKm),
      'pickupMinutes': serializer.toJson<double>(pickupMinutes),
      'tripMinutes': serializer.toJson<double>(tripMinutes),
      'passengerRating': serializer.toJson<double?>(passengerRating),
      'pickupRegion': serializer.toJson<String?>(pickupRegion),
      'surgeMultiplier': serializer.toJson<Decimal?>(surgeMultiplier),
      'rsPerKm': serializer.toJson<Decimal>(rsPerKm),
      'rsPerHour': serializer.toJson<Decimal>(rsPerHour),
      'costPerKmUsed': serializer.toJson<Decimal>(costPerKmUsed),
      'operatingCost': serializer.toJson<Decimal>(operatingCost),
      'realProfit': serializer.toJson<Decimal>(realProfit),
      'marginPercent': serializer.toJson<Decimal?>(marginPercent),
      'verdict': serializer.toJson<String>(
        $LocalRideEvaluationsTable.$converterverdict.toJson(verdict),
      ),
      'outcome': serializer.toJson<String>(
        $LocalRideEvaluationsTable.$converteroutcome.toJson(outcome),
      ),
      'workSessionClientId': serializer.toJson<String?>(workSessionClientId),
    };
  }

  LocalRide copyWith({
    String? clientId,
    RidePlatform? platform,
    DateTime? occurredAt,
    Decimal? fare,
    Decimal? pickupKm,
    Decimal? tripKm,
    double? pickupMinutes,
    double? tripMinutes,
    Value<double?> passengerRating = const Value.absent(),
    Value<String?> pickupRegion = const Value.absent(),
    Value<Decimal?> surgeMultiplier = const Value.absent(),
    Decimal? rsPerKm,
    Decimal? rsPerHour,
    Decimal? costPerKmUsed,
    Decimal? operatingCost,
    Decimal? realProfit,
    Value<Decimal?> marginPercent = const Value.absent(),
    RideVerdict? verdict,
    RideOutcome? outcome,
    Value<String?> workSessionClientId = const Value.absent(),
  }) => LocalRide(
    clientId: clientId ?? this.clientId,
    platform: platform ?? this.platform,
    occurredAt: occurredAt ?? this.occurredAt,
    fare: fare ?? this.fare,
    pickupKm: pickupKm ?? this.pickupKm,
    tripKm: tripKm ?? this.tripKm,
    pickupMinutes: pickupMinutes ?? this.pickupMinutes,
    tripMinutes: tripMinutes ?? this.tripMinutes,
    passengerRating: passengerRating.present
        ? passengerRating.value
        : this.passengerRating,
    pickupRegion: pickupRegion.present ? pickupRegion.value : this.pickupRegion,
    surgeMultiplier: surgeMultiplier.present
        ? surgeMultiplier.value
        : this.surgeMultiplier,
    rsPerKm: rsPerKm ?? this.rsPerKm,
    rsPerHour: rsPerHour ?? this.rsPerHour,
    costPerKmUsed: costPerKmUsed ?? this.costPerKmUsed,
    operatingCost: operatingCost ?? this.operatingCost,
    realProfit: realProfit ?? this.realProfit,
    marginPercent: marginPercent.present
        ? marginPercent.value
        : this.marginPercent,
    verdict: verdict ?? this.verdict,
    outcome: outcome ?? this.outcome,
    workSessionClientId: workSessionClientId.present
        ? workSessionClientId.value
        : this.workSessionClientId,
  );
  LocalRide copyWithCompanion(LocalRideEvaluationsCompanion data) {
    return LocalRide(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      platform: data.platform.present ? data.platform.value : this.platform,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      fare: data.fare.present ? data.fare.value : this.fare,
      pickupKm: data.pickupKm.present ? data.pickupKm.value : this.pickupKm,
      tripKm: data.tripKm.present ? data.tripKm.value : this.tripKm,
      pickupMinutes: data.pickupMinutes.present
          ? data.pickupMinutes.value
          : this.pickupMinutes,
      tripMinutes: data.tripMinutes.present
          ? data.tripMinutes.value
          : this.tripMinutes,
      passengerRating: data.passengerRating.present
          ? data.passengerRating.value
          : this.passengerRating,
      pickupRegion: data.pickupRegion.present
          ? data.pickupRegion.value
          : this.pickupRegion,
      surgeMultiplier: data.surgeMultiplier.present
          ? data.surgeMultiplier.value
          : this.surgeMultiplier,
      rsPerKm: data.rsPerKm.present ? data.rsPerKm.value : this.rsPerKm,
      rsPerHour: data.rsPerHour.present ? data.rsPerHour.value : this.rsPerHour,
      costPerKmUsed: data.costPerKmUsed.present
          ? data.costPerKmUsed.value
          : this.costPerKmUsed,
      operatingCost: data.operatingCost.present
          ? data.operatingCost.value
          : this.operatingCost,
      realProfit: data.realProfit.present
          ? data.realProfit.value
          : this.realProfit,
      marginPercent: data.marginPercent.present
          ? data.marginPercent.value
          : this.marginPercent,
      verdict: data.verdict.present ? data.verdict.value : this.verdict,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      workSessionClientId: data.workSessionClientId.present
          ? data.workSessionClientId.value
          : this.workSessionClientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalRide(')
          ..write('clientId: $clientId, ')
          ..write('platform: $platform, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('fare: $fare, ')
          ..write('pickupKm: $pickupKm, ')
          ..write('tripKm: $tripKm, ')
          ..write('pickupMinutes: $pickupMinutes, ')
          ..write('tripMinutes: $tripMinutes, ')
          ..write('passengerRating: $passengerRating, ')
          ..write('pickupRegion: $pickupRegion, ')
          ..write('surgeMultiplier: $surgeMultiplier, ')
          ..write('rsPerKm: $rsPerKm, ')
          ..write('rsPerHour: $rsPerHour, ')
          ..write('costPerKmUsed: $costPerKmUsed, ')
          ..write('operatingCost: $operatingCost, ')
          ..write('realProfit: $realProfit, ')
          ..write('marginPercent: $marginPercent, ')
          ..write('verdict: $verdict, ')
          ..write('outcome: $outcome, ')
          ..write('workSessionClientId: $workSessionClientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    platform,
    occurredAt,
    fare,
    pickupKm,
    tripKm,
    pickupMinutes,
    tripMinutes,
    passengerRating,
    pickupRegion,
    surgeMultiplier,
    rsPerKm,
    rsPerHour,
    costPerKmUsed,
    operatingCost,
    realProfit,
    marginPercent,
    verdict,
    outcome,
    workSessionClientId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalRide &&
          other.clientId == this.clientId &&
          other.platform == this.platform &&
          other.occurredAt == this.occurredAt &&
          other.fare == this.fare &&
          other.pickupKm == this.pickupKm &&
          other.tripKm == this.tripKm &&
          other.pickupMinutes == this.pickupMinutes &&
          other.tripMinutes == this.tripMinutes &&
          other.passengerRating == this.passengerRating &&
          other.pickupRegion == this.pickupRegion &&
          other.surgeMultiplier == this.surgeMultiplier &&
          other.rsPerKm == this.rsPerKm &&
          other.rsPerHour == this.rsPerHour &&
          other.costPerKmUsed == this.costPerKmUsed &&
          other.operatingCost == this.operatingCost &&
          other.realProfit == this.realProfit &&
          other.marginPercent == this.marginPercent &&
          other.verdict == this.verdict &&
          other.outcome == this.outcome &&
          other.workSessionClientId == this.workSessionClientId);
}

class LocalRideEvaluationsCompanion extends UpdateCompanion<LocalRide> {
  final Value<String> clientId;
  final Value<RidePlatform> platform;
  final Value<DateTime> occurredAt;
  final Value<Decimal> fare;
  final Value<Decimal> pickupKm;
  final Value<Decimal> tripKm;
  final Value<double> pickupMinutes;
  final Value<double> tripMinutes;
  final Value<double?> passengerRating;
  final Value<String?> pickupRegion;
  final Value<Decimal?> surgeMultiplier;
  final Value<Decimal> rsPerKm;
  final Value<Decimal> rsPerHour;
  final Value<Decimal> costPerKmUsed;
  final Value<Decimal> operatingCost;
  final Value<Decimal> realProfit;
  final Value<Decimal?> marginPercent;
  final Value<RideVerdict> verdict;
  final Value<RideOutcome> outcome;
  final Value<String?> workSessionClientId;
  final Value<int> rowid;
  const LocalRideEvaluationsCompanion({
    this.clientId = const Value.absent(),
    this.platform = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.fare = const Value.absent(),
    this.pickupKm = const Value.absent(),
    this.tripKm = const Value.absent(),
    this.pickupMinutes = const Value.absent(),
    this.tripMinutes = const Value.absent(),
    this.passengerRating = const Value.absent(),
    this.pickupRegion = const Value.absent(),
    this.surgeMultiplier = const Value.absent(),
    this.rsPerKm = const Value.absent(),
    this.rsPerHour = const Value.absent(),
    this.costPerKmUsed = const Value.absent(),
    this.operatingCost = const Value.absent(),
    this.realProfit = const Value.absent(),
    this.marginPercent = const Value.absent(),
    this.verdict = const Value.absent(),
    this.outcome = const Value.absent(),
    this.workSessionClientId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalRideEvaluationsCompanion.insert({
    required String clientId,
    required RidePlatform platform,
    required DateTime occurredAt,
    required Decimal fare,
    required Decimal pickupKm,
    required Decimal tripKm,
    this.pickupMinutes = const Value.absent(),
    this.tripMinutes = const Value.absent(),
    this.passengerRating = const Value.absent(),
    this.pickupRegion = const Value.absent(),
    this.surgeMultiplier = const Value.absent(),
    required Decimal rsPerKm,
    required Decimal rsPerHour,
    required Decimal costPerKmUsed,
    required Decimal operatingCost,
    required Decimal realProfit,
    this.marginPercent = const Value.absent(),
    required RideVerdict verdict,
    required RideOutcome outcome,
    this.workSessionClientId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       platform = Value(platform),
       occurredAt = Value(occurredAt),
       fare = Value(fare),
       pickupKm = Value(pickupKm),
       tripKm = Value(tripKm),
       rsPerKm = Value(rsPerKm),
       rsPerHour = Value(rsPerHour),
       costPerKmUsed = Value(costPerKmUsed),
       operatingCost = Value(operatingCost),
       realProfit = Value(realProfit),
       verdict = Value(verdict),
       outcome = Value(outcome);
  static Insertable<LocalRide> custom({
    Expression<String>? clientId,
    Expression<String>? platform,
    Expression<DateTime>? occurredAt,
    Expression<String>? fare,
    Expression<String>? pickupKm,
    Expression<String>? tripKm,
    Expression<double>? pickupMinutes,
    Expression<double>? tripMinutes,
    Expression<double>? passengerRating,
    Expression<String>? pickupRegion,
    Expression<String>? surgeMultiplier,
    Expression<String>? rsPerKm,
    Expression<String>? rsPerHour,
    Expression<String>? costPerKmUsed,
    Expression<String>? operatingCost,
    Expression<String>? realProfit,
    Expression<String>? marginPercent,
    Expression<String>? verdict,
    Expression<String>? outcome,
    Expression<String>? workSessionClientId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (platform != null) 'platform': platform,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (fare != null) 'fare': fare,
      if (pickupKm != null) 'pickup_km': pickupKm,
      if (tripKm != null) 'trip_km': tripKm,
      if (pickupMinutes != null) 'pickup_minutes': pickupMinutes,
      if (tripMinutes != null) 'trip_minutes': tripMinutes,
      if (passengerRating != null) 'passenger_rating': passengerRating,
      if (pickupRegion != null) 'pickup_region': pickupRegion,
      if (surgeMultiplier != null) 'surge_multiplier': surgeMultiplier,
      if (rsPerKm != null) 'rs_per_km': rsPerKm,
      if (rsPerHour != null) 'rs_per_hour': rsPerHour,
      if (costPerKmUsed != null) 'cost_per_km_used': costPerKmUsed,
      if (operatingCost != null) 'operating_cost': operatingCost,
      if (realProfit != null) 'real_profit': realProfit,
      if (marginPercent != null) 'margin_percent': marginPercent,
      if (verdict != null) 'verdict': verdict,
      if (outcome != null) 'outcome': outcome,
      if (workSessionClientId != null)
        'work_session_client_id': workSessionClientId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalRideEvaluationsCompanion copyWith({
    Value<String>? clientId,
    Value<RidePlatform>? platform,
    Value<DateTime>? occurredAt,
    Value<Decimal>? fare,
    Value<Decimal>? pickupKm,
    Value<Decimal>? tripKm,
    Value<double>? pickupMinutes,
    Value<double>? tripMinutes,
    Value<double?>? passengerRating,
    Value<String?>? pickupRegion,
    Value<Decimal?>? surgeMultiplier,
    Value<Decimal>? rsPerKm,
    Value<Decimal>? rsPerHour,
    Value<Decimal>? costPerKmUsed,
    Value<Decimal>? operatingCost,
    Value<Decimal>? realProfit,
    Value<Decimal?>? marginPercent,
    Value<RideVerdict>? verdict,
    Value<RideOutcome>? outcome,
    Value<String?>? workSessionClientId,
    Value<int>? rowid,
  }) {
    return LocalRideEvaluationsCompanion(
      clientId: clientId ?? this.clientId,
      platform: platform ?? this.platform,
      occurredAt: occurredAt ?? this.occurredAt,
      fare: fare ?? this.fare,
      pickupKm: pickupKm ?? this.pickupKm,
      tripKm: tripKm ?? this.tripKm,
      pickupMinutes: pickupMinutes ?? this.pickupMinutes,
      tripMinutes: tripMinutes ?? this.tripMinutes,
      passengerRating: passengerRating ?? this.passengerRating,
      pickupRegion: pickupRegion ?? this.pickupRegion,
      surgeMultiplier: surgeMultiplier ?? this.surgeMultiplier,
      rsPerKm: rsPerKm ?? this.rsPerKm,
      rsPerHour: rsPerHour ?? this.rsPerHour,
      costPerKmUsed: costPerKmUsed ?? this.costPerKmUsed,
      operatingCost: operatingCost ?? this.operatingCost,
      realProfit: realProfit ?? this.realProfit,
      marginPercent: marginPercent ?? this.marginPercent,
      verdict: verdict ?? this.verdict,
      outcome: outcome ?? this.outcome,
      workSessionClientId: workSessionClientId ?? this.workSessionClientId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterplatform.toSql(platform.value),
      );
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (fare.present) {
      map['fare'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterfare.toSql(fare.value),
      );
    }
    if (pickupKm.present) {
      map['pickup_km'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterpickupKm.toSql(pickupKm.value),
      );
    }
    if (tripKm.present) {
      map['trip_km'] = Variable<String>(
        $LocalRideEvaluationsTable.$convertertripKm.toSql(tripKm.value),
      );
    }
    if (pickupMinutes.present) {
      map['pickup_minutes'] = Variable<double>(pickupMinutes.value);
    }
    if (tripMinutes.present) {
      map['trip_minutes'] = Variable<double>(tripMinutes.value);
    }
    if (passengerRating.present) {
      map['passenger_rating'] = Variable<double>(passengerRating.value);
    }
    if (pickupRegion.present) {
      map['pickup_region'] = Variable<String>(pickupRegion.value);
    }
    if (surgeMultiplier.present) {
      map['surge_multiplier'] = Variable<String>(
        $LocalRideEvaluationsTable.$convertersurgeMultipliern.toSql(
          surgeMultiplier.value,
        ),
      );
    }
    if (rsPerKm.present) {
      map['rs_per_km'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterrsPerKm.toSql(rsPerKm.value),
      );
    }
    if (rsPerHour.present) {
      map['rs_per_hour'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterrsPerHour.toSql(rsPerHour.value),
      );
    }
    if (costPerKmUsed.present) {
      map['cost_per_km_used'] = Variable<String>(
        $LocalRideEvaluationsTable.$convertercostPerKmUsed.toSql(
          costPerKmUsed.value,
        ),
      );
    }
    if (operatingCost.present) {
      map['operating_cost'] = Variable<String>(
        $LocalRideEvaluationsTable.$converteroperatingCost.toSql(
          operatingCost.value,
        ),
      );
    }
    if (realProfit.present) {
      map['real_profit'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterrealProfit.toSql(realProfit.value),
      );
    }
    if (marginPercent.present) {
      map['margin_percent'] = Variable<String>(
        $LocalRideEvaluationsTable.$convertermarginPercentn.toSql(
          marginPercent.value,
        ),
      );
    }
    if (verdict.present) {
      map['verdict'] = Variable<String>(
        $LocalRideEvaluationsTable.$converterverdict.toSql(verdict.value),
      );
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(
        $LocalRideEvaluationsTable.$converteroutcome.toSql(outcome.value),
      );
    }
    if (workSessionClientId.present) {
      map['work_session_client_id'] = Variable<String>(
        workSessionClientId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalRideEvaluationsCompanion(')
          ..write('clientId: $clientId, ')
          ..write('platform: $platform, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('fare: $fare, ')
          ..write('pickupKm: $pickupKm, ')
          ..write('tripKm: $tripKm, ')
          ..write('pickupMinutes: $pickupMinutes, ')
          ..write('tripMinutes: $tripMinutes, ')
          ..write('passengerRating: $passengerRating, ')
          ..write('pickupRegion: $pickupRegion, ')
          ..write('surgeMultiplier: $surgeMultiplier, ')
          ..write('rsPerKm: $rsPerKm, ')
          ..write('rsPerHour: $rsPerHour, ')
          ..write('costPerKmUsed: $costPerKmUsed, ')
          ..write('operatingCost: $operatingCost, ')
          ..write('realProfit: $realProfit, ')
          ..write('marginPercent: $marginPercent, ')
          ..write('verdict: $verdict, ')
          ..write('outcome: $outcome, ')
          ..write('workSessionClientId: $workSessionClientId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalExpensesTable extends LocalExpenses
    with TableInfo<$LocalExpensesTable, LocalExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExpenseCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ExpenseCategory>($LocalExpensesTable.$convertercategory);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> amount =
      GeneratedColumn<String>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalExpensesTable.$converteramount);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> liters =
      GeneratedColumn<String>(
        'liters',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>($LocalExpensesTable.$converterlitersn);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> odometerKm =
      GeneratedColumn<String>(
        'odometer_km',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>($LocalExpensesTable.$converterodometerKmn);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workSessionClientIdMeta =
      const VerificationMeta('workSessionClientId');
  @override
  late final GeneratedColumn<String> workSessionClientId =
      GeneratedColumn<String>(
        'work_session_client_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    category,
    amount,
    liters,
    odometerKm,
    description,
    occurredAt,
    updatedAt,
    deletedAt,
    workSessionClientId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('work_session_client_id')) {
      context.handle(
        _workSessionClientIdMeta,
        workSessionClientId.isAcceptableOrUnknown(
          data['work_session_client_id']!,
          _workSessionClientIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalExpense(
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      category: $LocalExpensesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      amount: $LocalExpensesTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}amount'],
        )!,
      ),
      liters: $LocalExpensesTable.$converterlitersn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}liters'],
        ),
      ),
      odometerKm: $LocalExpensesTable.$converterodometerKmn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}odometer_km'],
        ),
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      workSessionClientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_session_client_id'],
      ),
    );
  }

  @override
  $LocalExpensesTable createAlias(String alias) {
    return $LocalExpensesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ExpenseCategory, String, String>
  $convertercategory = const EnumNameConverter<ExpenseCategory>(
    ExpenseCategory.values,
  );
  static TypeConverter<Decimal, String> $converteramount =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterliters =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $converterlitersn =
      NullAwareTypeConverter.wrap($converterliters);
  static TypeConverter<Decimal, String> $converterodometerKm =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $converterodometerKmn =
      NullAwareTypeConverter.wrap($converterodometerKm);
}

class LocalExpense extends DataClass implements Insertable<LocalExpense> {
  /// UUID gerado no dispositivo.
  final String clientId;

  /// Categoria da despesa.
  final ExpenseCategory category;

  /// Valor pago.
  final Decimal amount;

  /// Litros abastecidos, quando a categoria é combustível.
  final Decimal? liters;

  /// Leitura do odômetro, para aferir o consumo real.
  final Decimal? odometerKm;

  /// Descrição livre.
  final String? description;

  /// Momento da despesa.
  final DateTime occurredAt;

  /// Momento da última alteração, base do last-write-wins na sincronização.
  final DateTime updatedAt;

  /// Marca de exclusão lógica: a linha precisa sobreviver até sincronizar.
  final DateTime? deletedAt;

  /// Sessão de trabalho à qual a despesa pertence.
  final String? workSessionClientId;
  const LocalExpense({
    required this.clientId,
    required this.category,
    required this.amount,
    this.liters,
    this.odometerKm,
    this.description,
    required this.occurredAt,
    required this.updatedAt,
    this.deletedAt,
    this.workSessionClientId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    {
      map['category'] = Variable<String>(
        $LocalExpensesTable.$convertercategory.toSql(category),
      );
    }
    {
      map['amount'] = Variable<String>(
        $LocalExpensesTable.$converteramount.toSql(amount),
      );
    }
    if (!nullToAbsent || liters != null) {
      map['liters'] = Variable<String>(
        $LocalExpensesTable.$converterlitersn.toSql(liters),
      );
    }
    if (!nullToAbsent || odometerKm != null) {
      map['odometer_km'] = Variable<String>(
        $LocalExpensesTable.$converterodometerKmn.toSql(odometerKm),
      );
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || workSessionClientId != null) {
      map['work_session_client_id'] = Variable<String>(workSessionClientId);
    }
    return map;
  }

  LocalExpensesCompanion toCompanion(bool nullToAbsent) {
    return LocalExpensesCompanion(
      clientId: Value(clientId),
      category: Value(category),
      amount: Value(amount),
      liters: liters == null && nullToAbsent
          ? const Value.absent()
          : Value(liters),
      odometerKm: odometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(odometerKm),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      occurredAt: Value(occurredAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      workSessionClientId: workSessionClientId == null && nullToAbsent
          ? const Value.absent()
          : Value(workSessionClientId),
    );
  }

  factory LocalExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalExpense(
      clientId: serializer.fromJson<String>(json['clientId']),
      category: $LocalExpensesTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      amount: serializer.fromJson<Decimal>(json['amount']),
      liters: serializer.fromJson<Decimal?>(json['liters']),
      odometerKm: serializer.fromJson<Decimal?>(json['odometerKm']),
      description: serializer.fromJson<String?>(json['description']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      workSessionClientId: serializer.fromJson<String?>(
        json['workSessionClientId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'category': serializer.toJson<String>(
        $LocalExpensesTable.$convertercategory.toJson(category),
      ),
      'amount': serializer.toJson<Decimal>(amount),
      'liters': serializer.toJson<Decimal?>(liters),
      'odometerKm': serializer.toJson<Decimal?>(odometerKm),
      'description': serializer.toJson<String?>(description),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'workSessionClientId': serializer.toJson<String?>(workSessionClientId),
    };
  }

  LocalExpense copyWith({
    String? clientId,
    ExpenseCategory? category,
    Decimal? amount,
    Value<Decimal?> liters = const Value.absent(),
    Value<Decimal?> odometerKm = const Value.absent(),
    Value<String?> description = const Value.absent(),
    DateTime? occurredAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> workSessionClientId = const Value.absent(),
  }) => LocalExpense(
    clientId: clientId ?? this.clientId,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    liters: liters.present ? liters.value : this.liters,
    odometerKm: odometerKm.present ? odometerKm.value : this.odometerKm,
    description: description.present ? description.value : this.description,
    occurredAt: occurredAt ?? this.occurredAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    workSessionClientId: workSessionClientId.present
        ? workSessionClientId.value
        : this.workSessionClientId,
  );
  LocalExpense copyWithCompanion(LocalExpensesCompanion data) {
    return LocalExpense(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      liters: data.liters.present ? data.liters.value : this.liters,
      odometerKm: data.odometerKm.present
          ? data.odometerKm.value
          : this.odometerKm,
      description: data.description.present
          ? data.description.value
          : this.description,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      workSessionClientId: data.workSessionClientId.present
          ? data.workSessionClientId.value
          : this.workSessionClientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpense(')
          ..write('clientId: $clientId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('liters: $liters, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('description: $description, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('workSessionClientId: $workSessionClientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    category,
    amount,
    liters,
    odometerKm,
    description,
    occurredAt,
    updatedAt,
    deletedAt,
    workSessionClientId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalExpense &&
          other.clientId == this.clientId &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.liters == this.liters &&
          other.odometerKm == this.odometerKm &&
          other.description == this.description &&
          other.occurredAt == this.occurredAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.workSessionClientId == this.workSessionClientId);
}

class LocalExpensesCompanion extends UpdateCompanion<LocalExpense> {
  final Value<String> clientId;
  final Value<ExpenseCategory> category;
  final Value<Decimal> amount;
  final Value<Decimal?> liters;
  final Value<Decimal?> odometerKm;
  final Value<String?> description;
  final Value<DateTime> occurredAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> workSessionClientId;
  final Value<int> rowid;
  const LocalExpensesCompanion({
    this.clientId = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.liters = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.description = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.workSessionClientId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalExpensesCompanion.insert({
    required String clientId,
    required ExpenseCategory category,
    required Decimal amount,
    this.liters = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime occurredAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.workSessionClientId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       category = Value(category),
       amount = Value(amount),
       occurredAt = Value(occurredAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalExpense> custom({
    Expression<String>? clientId,
    Expression<String>? category,
    Expression<String>? amount,
    Expression<String>? liters,
    Expression<String>? odometerKm,
    Expression<String>? description,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? workSessionClientId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (liters != null) 'liters': liters,
      if (odometerKm != null) 'odometer_km': odometerKm,
      if (description != null) 'description': description,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (workSessionClientId != null)
        'work_session_client_id': workSessionClientId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalExpensesCompanion copyWith({
    Value<String>? clientId,
    Value<ExpenseCategory>? category,
    Value<Decimal>? amount,
    Value<Decimal?>? liters,
    Value<Decimal?>? odometerKm,
    Value<String?>? description,
    Value<DateTime>? occurredAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? workSessionClientId,
    Value<int>? rowid,
  }) {
    return LocalExpensesCompanion(
      clientId: clientId ?? this.clientId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      liters: liters ?? this.liters,
      odometerKm: odometerKm ?? this.odometerKm,
      description: description ?? this.description,
      occurredAt: occurredAt ?? this.occurredAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      workSessionClientId: workSessionClientId ?? this.workSessionClientId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $LocalExpensesTable.$convertercategory.toSql(category.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<String>(
        $LocalExpensesTable.$converteramount.toSql(amount.value),
      );
    }
    if (liters.present) {
      map['liters'] = Variable<String>(
        $LocalExpensesTable.$converterlitersn.toSql(liters.value),
      );
    }
    if (odometerKm.present) {
      map['odometer_km'] = Variable<String>(
        $LocalExpensesTable.$converterodometerKmn.toSql(odometerKm.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (workSessionClientId.present) {
      map['work_session_client_id'] = Variable<String>(
        workSessionClientId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpensesCompanion(')
          ..write('clientId: $clientId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('liters: $liters, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('description: $description, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('workSessionClientId: $workSessionClientId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalWorkSessionsTable extends LocalWorkSessions
    with TableInfo<$LocalWorkSessionsTable, LocalWorkSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalWorkSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [clientId, startedAt, endedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_work_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalWorkSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalWorkSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalWorkSession(
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
    );
  }

  @override
  $LocalWorkSessionsTable createAlias(String alias) {
    return $LocalWorkSessionsTable(attachedDatabase, alias);
  }
}

class LocalWorkSession extends DataClass
    implements Insertable<LocalWorkSession> {
  /// UUID gerado no dispositivo.
  final String clientId;

  /// Início da sessão.
  final DateTime startedAt;

  /// Fim da sessão. Nulo enquanto estiver aberta.
  final DateTime? endedAt;
  const LocalWorkSession({
    required this.clientId,
    required this.startedAt,
    this.endedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    return map;
  }

  LocalWorkSessionsCompanion toCompanion(bool nullToAbsent) {
    return LocalWorkSessionsCompanion(
      clientId: Value(clientId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory LocalWorkSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWorkSession(
      clientId: serializer.fromJson<String>(json['clientId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
    };
  }

  LocalWorkSession copyWith({
    String? clientId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
  }) => LocalWorkSession(
    clientId: clientId ?? this.clientId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
  );
  LocalWorkSession copyWithCompanion(LocalWorkSessionsCompanion data) {
    return LocalWorkSession(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWorkSession(')
          ..write('clientId: $clientId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(clientId, startedAt, endedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalWorkSession &&
          other.clientId == this.clientId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt);
}

class LocalWorkSessionsCompanion extends UpdateCompanion<LocalWorkSession> {
  final Value<String> clientId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> rowid;
  const LocalWorkSessionsCompanion({
    this.clientId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWorkSessionsCompanion.insert({
    required String clientId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       startedAt = Value(startedAt);
  static Insertable<LocalWorkSession> custom({
    Expression<String>? clientId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWorkSessionsCompanion copyWith({
    Value<String>? clientId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? rowid,
  }) {
    return LocalWorkSessionsCompanion(
      clientId: clientId ?? this.clientId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalWorkSessionsCompanion(')
          ..write('clientId: $clientId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxEntriesTable extends OutboxEntries
    with TableInfo<$OutboxEntriesTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<OutboxKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<OutboxKind>($OutboxEntriesTable.$converterkind);
  static const VerificationMeta _entityClientIdMeta = const VerificationMeta(
    'entityClientId',
  );
  @override
  late final GeneratedColumn<String> entityClientId = GeneratedColumn<String>(
    'entity_client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    entityClientId,
    createdAt,
    attempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_client_id')) {
      context.handle(
        _entityClientIdMeta,
        entityClientId.isAcceptableOrUnknown(
          data['entity_client_id']!,
          _entityClientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entityClientIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $OutboxEntriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      entityClientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_client_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $OutboxEntriesTable createAlias(String alias) {
    return $OutboxEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OutboxKind, String, String> $converterkind =
      const EnumNameConverter<OutboxKind>(OutboxKind.values);
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  /// Ordem de enfileiramento.
  final int id;

  /// Tipo de operação.
  final OutboxKind kind;

  /// `clientId` da entidade afetada.
  final String entityClientId;

  /// Momento do enfileiramento.
  final DateTime createdAt;

  /// Número de tentativas de envio já feitas.
  final int attempts;

  /// Erro da última tentativa, para diagnóstico.
  final String? lastError;
  const OutboxEntry({
    required this.id,
    required this.kind,
    required this.entityClientId,
    required this.createdAt,
    required this.attempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>(
        $OutboxEntriesTable.$converterkind.toSql(kind),
      );
    }
    map['entity_client_id'] = Variable<String>(entityClientId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  OutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return OutboxEntriesCompanion(
      id: Value(id),
      kind: Value(kind),
      entityClientId: Value(entityClientId),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<int>(json['id']),
      kind: $OutboxEntriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      entityClientId: serializer.fromJson<String>(json['entityClientId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(
        $OutboxEntriesTable.$converterkind.toJson(kind),
      ),
      'entityClientId': serializer.toJson<String>(entityClientId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  OutboxEntry copyWith({
    int? id,
    OutboxKind? kind,
    String? entityClientId,
    DateTime? createdAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
  }) => OutboxEntry(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    entityClientId: entityClientId ?? this.entityClientId,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  OutboxEntry copyWithCompanion(OutboxEntriesCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      entityClientId: data.entityClientId.present
          ? data.entityClientId.value
          : this.entityClientId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('entityClientId: $entityClientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, entityClientId, createdAt, attempts, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.entityClientId == this.entityClientId &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class OutboxEntriesCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<int> id;
  final Value<OutboxKind> kind;
  final Value<String> entityClientId;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  const OutboxEntriesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.entityClientId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  OutboxEntriesCompanion.insert({
    this.id = const Value.absent(),
    required OutboxKind kind,
    required String entityClientId,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  }) : kind = Value(kind),
       entityClientId = Value(entityClientId),
       createdAt = Value(createdAt);
  static Insertable<OutboxEntry> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? entityClientId,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (entityClientId != null) 'entity_client_id': entityClientId,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
    });
  }

  OutboxEntriesCompanion copyWith({
    Value<int>? id,
    Value<OutboxKind>? kind,
    Value<String>? entityClientId,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<String?>? lastError,
  }) {
    return OutboxEntriesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      entityClientId: entityClientId ?? this.entityClientId,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $OutboxEntriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (entityClientId.present) {
      map['entity_client_id'] = Variable<String>(entityClientId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntriesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('entityClientId: $entityClientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

class $LocalVehiclesTable extends LocalVehicles
    with TableInfo<$LocalVehiclesTable, LocalVehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _makeMeta = const VerificationMeta('make');
  @override
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
    'make',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelYearMeta = const VerificationMeta(
    'modelYear',
  );
  @override
  late final GeneratedColumn<int> modelYear = GeneratedColumn<int>(
    'model_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plateSuffixMeta = const VerificationMeta(
    'plateSuffix',
  );
  @override
  late final GeneratedColumn<String> plateSuffix = GeneratedColumn<String>(
    'plate_suffix',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FuelType, String> fuel =
      GeneratedColumn<String>(
        'fuel',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FuelType>($LocalVehiclesTable.$converterfuel);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> consumption =
      GeneratedColumn<String>(
        'consumption',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalVehiclesTable.$converterconsumption);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> fuelPrice =
      GeneratedColumn<String>(
        'fuel_price',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalVehiclesTable.$converterfuelPrice);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> marketValue =
      GeneratedColumn<String>(
        'market_value',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>($LocalVehiclesTable.$convertermarketValuen);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String>
  depreciationPerKm = GeneratedColumn<String>(
    'depreciation_per_km',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Decimal>($LocalVehiclesTable.$converterdepreciationPerKm);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String>
  genericMaintenancePerKm =
      GeneratedColumn<String>(
        'generic_maintenance_per_km',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>(
        $LocalVehiclesTable.$convertergenericMaintenancePerKm,
      );
  static const VerificationMeta _workDaysPerMonthMeta = const VerificationMeta(
    'workDaysPerMonth',
  );
  @override
  late final GeneratedColumn<int> workDaysPerMonth = GeneratedColumn<int>(
    'work_days_per_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> kmPerDay =
      GeneratedColumn<String>(
        'km_per_day',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalVehiclesTable.$converterkmPerDay);
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    nickname,
    make,
    model,
    modelYear,
    plateSuffix,
    fuel,
    consumption,
    fuelPrice,
    marketValue,
    depreciationPerKm,
    genericMaintenancePerKm,
    workDaysPerMonth,
    kmPerDay,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('make')) {
      context.handle(
        _makeMeta,
        make.isAcceptableOrUnknown(data['make']!, _makeMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('model_year')) {
      context.handle(
        _modelYearMeta,
        modelYear.isAcceptableOrUnknown(data['model_year']!, _modelYearMeta),
      );
    }
    if (data.containsKey('plate_suffix')) {
      context.handle(
        _plateSuffixMeta,
        plateSuffix.isAcceptableOrUnknown(
          data['plate_suffix']!,
          _plateSuffixMeta,
        ),
      );
    }
    if (data.containsKey('work_days_per_month')) {
      context.handle(
        _workDaysPerMonthMeta,
        workDaysPerMonth.isAcceptableOrUnknown(
          data['work_days_per_month']!,
          _workDaysPerMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workDaysPerMonthMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalVehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVehicle(
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      make: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}make'],
      ),
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      modelYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}model_year'],
      ),
      plateSuffix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate_suffix'],
      ),
      fuel: $LocalVehiclesTable.$converterfuel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fuel'],
        )!,
      ),
      consumption: $LocalVehiclesTable.$converterconsumption.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}consumption'],
        )!,
      ),
      fuelPrice: $LocalVehiclesTable.$converterfuelPrice.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fuel_price'],
        )!,
      ),
      marketValue: $LocalVehiclesTable.$convertermarketValuen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}market_value'],
        ),
      ),
      depreciationPerKm: $LocalVehiclesTable.$converterdepreciationPerKm
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}depreciation_per_km'],
            )!,
          ),
      genericMaintenancePerKm: $LocalVehiclesTable
          .$convertergenericMaintenancePerKm
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}generic_maintenance_per_km'],
            )!,
          ),
      workDaysPerMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_days_per_month'],
      )!,
      kmPerDay: $LocalVehiclesTable.$converterkmPerDay.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}km_per_day'],
        )!,
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LocalVehiclesTable createAlias(String alias) {
    return $LocalVehiclesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FuelType, String, String> $converterfuel =
      const EnumNameConverter<FuelType>(FuelType.values);
  static TypeConverter<Decimal, String> $converterconsumption =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterfuelPrice =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $convertermarketValue =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $convertermarketValuen =
      NullAwareTypeConverter.wrap($convertermarketValue);
  static TypeConverter<Decimal, String> $converterdepreciationPerKm =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $convertergenericMaintenancePerKm =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterkmPerDay =
      const DecimalConverter();
}

class LocalVehicle extends DataClass implements Insertable<LocalVehicle> {
  /// UUID gerado no dispositivo.
  final String clientId;

  /// Apelido para o motorista distinguir seus veículos.
  final String nickname;

  /// Marca.
  final String? make;

  /// Modelo.
  final String? model;

  /// Ano do modelo.
  final int? modelYear;

  /// Quatro últimos caracteres da placa. Nunca a placa inteira.
  final String? plateSuffix;

  /// Tipo de combustível.
  final FuelType fuel;

  /// Consumo médio, em km por litro ou por kWh.
  final Decimal consumption;

  /// Preço do litro ou do kWh.
  final Decimal fuelPrice;

  /// Valor de mercado (FIPE), base da depreciação.
  final Decimal? marketValue;

  /// Depreciação por km rodado.
  final Decimal depreciationPerKm;

  /// Manutenção genérica por km, para o que não foi detalhado.
  final Decimal genericMaintenancePerKm;

  /// Dias trabalhados por mês, base do rateio dos custos fixos.
  final int workDaysPerMonth;

  /// Quilometragem média por dia trabalhado.
  final Decimal kmPerDay;

  /// Momento da última alteração, para o last-write-wins da sincronização.
  final DateTime updatedAt;

  /// Exclusão lógica.
  final DateTime? deletedAt;
  const LocalVehicle({
    required this.clientId,
    required this.nickname,
    this.make,
    this.model,
    this.modelYear,
    this.plateSuffix,
    required this.fuel,
    required this.consumption,
    required this.fuelPrice,
    this.marketValue,
    required this.depreciationPerKm,
    required this.genericMaintenancePerKm,
    required this.workDaysPerMonth,
    required this.kmPerDay,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || make != null) {
      map['make'] = Variable<String>(make);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || modelYear != null) {
      map['model_year'] = Variable<int>(modelYear);
    }
    if (!nullToAbsent || plateSuffix != null) {
      map['plate_suffix'] = Variable<String>(plateSuffix);
    }
    {
      map['fuel'] = Variable<String>(
        $LocalVehiclesTable.$converterfuel.toSql(fuel),
      );
    }
    {
      map['consumption'] = Variable<String>(
        $LocalVehiclesTable.$converterconsumption.toSql(consumption),
      );
    }
    {
      map['fuel_price'] = Variable<String>(
        $LocalVehiclesTable.$converterfuelPrice.toSql(fuelPrice),
      );
    }
    if (!nullToAbsent || marketValue != null) {
      map['market_value'] = Variable<String>(
        $LocalVehiclesTable.$convertermarketValuen.toSql(marketValue),
      );
    }
    {
      map['depreciation_per_km'] = Variable<String>(
        $LocalVehiclesTable.$converterdepreciationPerKm.toSql(
          depreciationPerKm,
        ),
      );
    }
    {
      map['generic_maintenance_per_km'] = Variable<String>(
        $LocalVehiclesTable.$convertergenericMaintenancePerKm.toSql(
          genericMaintenancePerKm,
        ),
      );
    }
    map['work_days_per_month'] = Variable<int>(workDaysPerMonth);
    {
      map['km_per_day'] = Variable<String>(
        $LocalVehiclesTable.$converterkmPerDay.toSql(kmPerDay),
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LocalVehiclesCompanion toCompanion(bool nullToAbsent) {
    return LocalVehiclesCompanion(
      clientId: Value(clientId),
      nickname: Value(nickname),
      make: make == null && nullToAbsent ? const Value.absent() : Value(make),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      modelYear: modelYear == null && nullToAbsent
          ? const Value.absent()
          : Value(modelYear),
      plateSuffix: plateSuffix == null && nullToAbsent
          ? const Value.absent()
          : Value(plateSuffix),
      fuel: Value(fuel),
      consumption: Value(consumption),
      fuelPrice: Value(fuelPrice),
      marketValue: marketValue == null && nullToAbsent
          ? const Value.absent()
          : Value(marketValue),
      depreciationPerKm: Value(depreciationPerKm),
      genericMaintenancePerKm: Value(genericMaintenancePerKm),
      workDaysPerMonth: Value(workDaysPerMonth),
      kmPerDay: Value(kmPerDay),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LocalVehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVehicle(
      clientId: serializer.fromJson<String>(json['clientId']),
      nickname: serializer.fromJson<String>(json['nickname']),
      make: serializer.fromJson<String?>(json['make']),
      model: serializer.fromJson<String?>(json['model']),
      modelYear: serializer.fromJson<int?>(json['modelYear']),
      plateSuffix: serializer.fromJson<String?>(json['plateSuffix']),
      fuel: $LocalVehiclesTable.$converterfuel.fromJson(
        serializer.fromJson<String>(json['fuel']),
      ),
      consumption: serializer.fromJson<Decimal>(json['consumption']),
      fuelPrice: serializer.fromJson<Decimal>(json['fuelPrice']),
      marketValue: serializer.fromJson<Decimal?>(json['marketValue']),
      depreciationPerKm: serializer.fromJson<Decimal>(
        json['depreciationPerKm'],
      ),
      genericMaintenancePerKm: serializer.fromJson<Decimal>(
        json['genericMaintenancePerKm'],
      ),
      workDaysPerMonth: serializer.fromJson<int>(json['workDaysPerMonth']),
      kmPerDay: serializer.fromJson<Decimal>(json['kmPerDay']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'nickname': serializer.toJson<String>(nickname),
      'make': serializer.toJson<String?>(make),
      'model': serializer.toJson<String?>(model),
      'modelYear': serializer.toJson<int?>(modelYear),
      'plateSuffix': serializer.toJson<String?>(plateSuffix),
      'fuel': serializer.toJson<String>(
        $LocalVehiclesTable.$converterfuel.toJson(fuel),
      ),
      'consumption': serializer.toJson<Decimal>(consumption),
      'fuelPrice': serializer.toJson<Decimal>(fuelPrice),
      'marketValue': serializer.toJson<Decimal?>(marketValue),
      'depreciationPerKm': serializer.toJson<Decimal>(depreciationPerKm),
      'genericMaintenancePerKm': serializer.toJson<Decimal>(
        genericMaintenancePerKm,
      ),
      'workDaysPerMonth': serializer.toJson<int>(workDaysPerMonth),
      'kmPerDay': serializer.toJson<Decimal>(kmPerDay),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  LocalVehicle copyWith({
    String? clientId,
    String? nickname,
    Value<String?> make = const Value.absent(),
    Value<String?> model = const Value.absent(),
    Value<int?> modelYear = const Value.absent(),
    Value<String?> plateSuffix = const Value.absent(),
    FuelType? fuel,
    Decimal? consumption,
    Decimal? fuelPrice,
    Value<Decimal?> marketValue = const Value.absent(),
    Decimal? depreciationPerKm,
    Decimal? genericMaintenancePerKm,
    int? workDaysPerMonth,
    Decimal? kmPerDay,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => LocalVehicle(
    clientId: clientId ?? this.clientId,
    nickname: nickname ?? this.nickname,
    make: make.present ? make.value : this.make,
    model: model.present ? model.value : this.model,
    modelYear: modelYear.present ? modelYear.value : this.modelYear,
    plateSuffix: plateSuffix.present ? plateSuffix.value : this.plateSuffix,
    fuel: fuel ?? this.fuel,
    consumption: consumption ?? this.consumption,
    fuelPrice: fuelPrice ?? this.fuelPrice,
    marketValue: marketValue.present ? marketValue.value : this.marketValue,
    depreciationPerKm: depreciationPerKm ?? this.depreciationPerKm,
    genericMaintenancePerKm:
        genericMaintenancePerKm ?? this.genericMaintenancePerKm,
    workDaysPerMonth: workDaysPerMonth ?? this.workDaysPerMonth,
    kmPerDay: kmPerDay ?? this.kmPerDay,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LocalVehicle copyWithCompanion(LocalVehiclesCompanion data) {
    return LocalVehicle(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      modelYear: data.modelYear.present ? data.modelYear.value : this.modelYear,
      plateSuffix: data.plateSuffix.present
          ? data.plateSuffix.value
          : this.plateSuffix,
      fuel: data.fuel.present ? data.fuel.value : this.fuel,
      consumption: data.consumption.present
          ? data.consumption.value
          : this.consumption,
      fuelPrice: data.fuelPrice.present ? data.fuelPrice.value : this.fuelPrice,
      marketValue: data.marketValue.present
          ? data.marketValue.value
          : this.marketValue,
      depreciationPerKm: data.depreciationPerKm.present
          ? data.depreciationPerKm.value
          : this.depreciationPerKm,
      genericMaintenancePerKm: data.genericMaintenancePerKm.present
          ? data.genericMaintenancePerKm.value
          : this.genericMaintenancePerKm,
      workDaysPerMonth: data.workDaysPerMonth.present
          ? data.workDaysPerMonth.value
          : this.workDaysPerMonth,
      kmPerDay: data.kmPerDay.present ? data.kmPerDay.value : this.kmPerDay,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVehicle(')
          ..write('clientId: $clientId, ')
          ..write('nickname: $nickname, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('modelYear: $modelYear, ')
          ..write('plateSuffix: $plateSuffix, ')
          ..write('fuel: $fuel, ')
          ..write('consumption: $consumption, ')
          ..write('fuelPrice: $fuelPrice, ')
          ..write('marketValue: $marketValue, ')
          ..write('depreciationPerKm: $depreciationPerKm, ')
          ..write('genericMaintenancePerKm: $genericMaintenancePerKm, ')
          ..write('workDaysPerMonth: $workDaysPerMonth, ')
          ..write('kmPerDay: $kmPerDay, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    nickname,
    make,
    model,
    modelYear,
    plateSuffix,
    fuel,
    consumption,
    fuelPrice,
    marketValue,
    depreciationPerKm,
    genericMaintenancePerKm,
    workDaysPerMonth,
    kmPerDay,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVehicle &&
          other.clientId == this.clientId &&
          other.nickname == this.nickname &&
          other.make == this.make &&
          other.model == this.model &&
          other.modelYear == this.modelYear &&
          other.plateSuffix == this.plateSuffix &&
          other.fuel == this.fuel &&
          other.consumption == this.consumption &&
          other.fuelPrice == this.fuelPrice &&
          other.marketValue == this.marketValue &&
          other.depreciationPerKm == this.depreciationPerKm &&
          other.genericMaintenancePerKm == this.genericMaintenancePerKm &&
          other.workDaysPerMonth == this.workDaysPerMonth &&
          other.kmPerDay == this.kmPerDay &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class LocalVehiclesCompanion extends UpdateCompanion<LocalVehicle> {
  final Value<String> clientId;
  final Value<String> nickname;
  final Value<String?> make;
  final Value<String?> model;
  final Value<int?> modelYear;
  final Value<String?> plateSuffix;
  final Value<FuelType> fuel;
  final Value<Decimal> consumption;
  final Value<Decimal> fuelPrice;
  final Value<Decimal?> marketValue;
  final Value<Decimal> depreciationPerKm;
  final Value<Decimal> genericMaintenancePerKm;
  final Value<int> workDaysPerMonth;
  final Value<Decimal> kmPerDay;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const LocalVehiclesCompanion({
    this.clientId = const Value.absent(),
    this.nickname = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.modelYear = const Value.absent(),
    this.plateSuffix = const Value.absent(),
    this.fuel = const Value.absent(),
    this.consumption = const Value.absent(),
    this.fuelPrice = const Value.absent(),
    this.marketValue = const Value.absent(),
    this.depreciationPerKm = const Value.absent(),
    this.genericMaintenancePerKm = const Value.absent(),
    this.workDaysPerMonth = const Value.absent(),
    this.kmPerDay = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVehiclesCompanion.insert({
    required String clientId,
    required String nickname,
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.modelYear = const Value.absent(),
    this.plateSuffix = const Value.absent(),
    required FuelType fuel,
    required Decimal consumption,
    required Decimal fuelPrice,
    this.marketValue = const Value.absent(),
    required Decimal depreciationPerKm,
    required Decimal genericMaintenancePerKm,
    required int workDaysPerMonth,
    required Decimal kmPerDay,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       nickname = Value(nickname),
       fuel = Value(fuel),
       consumption = Value(consumption),
       fuelPrice = Value(fuelPrice),
       depreciationPerKm = Value(depreciationPerKm),
       genericMaintenancePerKm = Value(genericMaintenancePerKm),
       workDaysPerMonth = Value(workDaysPerMonth),
       kmPerDay = Value(kmPerDay),
       updatedAt = Value(updatedAt);
  static Insertable<LocalVehicle> custom({
    Expression<String>? clientId,
    Expression<String>? nickname,
    Expression<String>? make,
    Expression<String>? model,
    Expression<int>? modelYear,
    Expression<String>? plateSuffix,
    Expression<String>? fuel,
    Expression<String>? consumption,
    Expression<String>? fuelPrice,
    Expression<String>? marketValue,
    Expression<String>? depreciationPerKm,
    Expression<String>? genericMaintenancePerKm,
    Expression<int>? workDaysPerMonth,
    Expression<String>? kmPerDay,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (nickname != null) 'nickname': nickname,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (modelYear != null) 'model_year': modelYear,
      if (plateSuffix != null) 'plate_suffix': plateSuffix,
      if (fuel != null) 'fuel': fuel,
      if (consumption != null) 'consumption': consumption,
      if (fuelPrice != null) 'fuel_price': fuelPrice,
      if (marketValue != null) 'market_value': marketValue,
      if (depreciationPerKm != null) 'depreciation_per_km': depreciationPerKm,
      if (genericMaintenancePerKm != null)
        'generic_maintenance_per_km': genericMaintenancePerKm,
      if (workDaysPerMonth != null) 'work_days_per_month': workDaysPerMonth,
      if (kmPerDay != null) 'km_per_day': kmPerDay,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVehiclesCompanion copyWith({
    Value<String>? clientId,
    Value<String>? nickname,
    Value<String?>? make,
    Value<String?>? model,
    Value<int?>? modelYear,
    Value<String?>? plateSuffix,
    Value<FuelType>? fuel,
    Value<Decimal>? consumption,
    Value<Decimal>? fuelPrice,
    Value<Decimal?>? marketValue,
    Value<Decimal>? depreciationPerKm,
    Value<Decimal>? genericMaintenancePerKm,
    Value<int>? workDaysPerMonth,
    Value<Decimal>? kmPerDay,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LocalVehiclesCompanion(
      clientId: clientId ?? this.clientId,
      nickname: nickname ?? this.nickname,
      make: make ?? this.make,
      model: model ?? this.model,
      modelYear: modelYear ?? this.modelYear,
      plateSuffix: plateSuffix ?? this.plateSuffix,
      fuel: fuel ?? this.fuel,
      consumption: consumption ?? this.consumption,
      fuelPrice: fuelPrice ?? this.fuelPrice,
      marketValue: marketValue ?? this.marketValue,
      depreciationPerKm: depreciationPerKm ?? this.depreciationPerKm,
      genericMaintenancePerKm:
          genericMaintenancePerKm ?? this.genericMaintenancePerKm,
      workDaysPerMonth: workDaysPerMonth ?? this.workDaysPerMonth,
      kmPerDay: kmPerDay ?? this.kmPerDay,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (modelYear.present) {
      map['model_year'] = Variable<int>(modelYear.value);
    }
    if (plateSuffix.present) {
      map['plate_suffix'] = Variable<String>(plateSuffix.value);
    }
    if (fuel.present) {
      map['fuel'] = Variable<String>(
        $LocalVehiclesTable.$converterfuel.toSql(fuel.value),
      );
    }
    if (consumption.present) {
      map['consumption'] = Variable<String>(
        $LocalVehiclesTable.$converterconsumption.toSql(consumption.value),
      );
    }
    if (fuelPrice.present) {
      map['fuel_price'] = Variable<String>(
        $LocalVehiclesTable.$converterfuelPrice.toSql(fuelPrice.value),
      );
    }
    if (marketValue.present) {
      map['market_value'] = Variable<String>(
        $LocalVehiclesTable.$convertermarketValuen.toSql(marketValue.value),
      );
    }
    if (depreciationPerKm.present) {
      map['depreciation_per_km'] = Variable<String>(
        $LocalVehiclesTable.$converterdepreciationPerKm.toSql(
          depreciationPerKm.value,
        ),
      );
    }
    if (genericMaintenancePerKm.present) {
      map['generic_maintenance_per_km'] = Variable<String>(
        $LocalVehiclesTable.$convertergenericMaintenancePerKm.toSql(
          genericMaintenancePerKm.value,
        ),
      );
    }
    if (workDaysPerMonth.present) {
      map['work_days_per_month'] = Variable<int>(workDaysPerMonth.value);
    }
    if (kmPerDay.present) {
      map['km_per_day'] = Variable<String>(
        $LocalVehiclesTable.$converterkmPerDay.toSql(kmPerDay.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVehiclesCompanion(')
          ..write('clientId: $clientId, ')
          ..write('nickname: $nickname, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('modelYear: $modelYear, ')
          ..write('plateSuffix: $plateSuffix, ')
          ..write('fuel: $fuel, ')
          ..write('consumption: $consumption, ')
          ..write('fuelPrice: $fuelPrice, ')
          ..write('marketValue: $marketValue, ')
          ..write('depreciationPerKm: $depreciationPerKm, ')
          ..write('genericMaintenancePerKm: $genericMaintenancePerKm, ')
          ..write('workDaysPerMonth: $workDaysPerMonth, ')
          ..write('kmPerDay: $kmPerDay, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalMaintenanceItemsTable extends LocalMaintenanceItems
    with TableInfo<$LocalMaintenanceItemsTable, LocalMaintenanceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMaintenanceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleClientIdMeta = const VerificationMeta(
    'vehicleClientId',
  );
  @override
  late final GeneratedColumn<String> vehicleClientId = GeneratedColumn<String>(
    'vehicle_client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_vehicles (client_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> cost =
      GeneratedColumn<String>(
        'cost',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalMaintenanceItemsTable.$convertercost);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> intervalKm =
      GeneratedColumn<String>(
        'interval_km',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>(
        $LocalMaintenanceItemsTable.$converterintervalKm,
      );
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    vehicleClientId,
    label,
    cost,
    intervalKm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_maintenance_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalMaintenanceItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('vehicle_client_id')) {
      context.handle(
        _vehicleClientIdMeta,
        vehicleClientId.isAcceptableOrUnknown(
          data['vehicle_client_id']!,
          _vehicleClientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vehicleClientIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalMaintenanceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMaintenanceItem(
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      vehicleClientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_client_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      cost: $LocalMaintenanceItemsTable.$convertercost.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cost'],
        )!,
      ),
      intervalKm: $LocalMaintenanceItemsTable.$converterintervalKm.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}interval_km'],
        )!,
      ),
    );
  }

  @override
  $LocalMaintenanceItemsTable createAlias(String alias) {
    return $LocalMaintenanceItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<Decimal, String> $convertercost =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterintervalKm =
      const DecimalConverter();
}

class LocalMaintenanceItem extends DataClass
    implements Insertable<LocalMaintenanceItem> {
  /// UUID gerado no dispositivo.
  final String clientId;

  /// Veículo ao qual o item pertence.
  final String vehicleClientId;

  /// Descrição, por exemplo "Troca de óleo".
  final String label;

  /// Custo do serviço ou peça.
  final Decimal cost;

  /// Intervalo de troca, em km.
  final Decimal intervalKm;
  const LocalMaintenanceItem({
    required this.clientId,
    required this.vehicleClientId,
    required this.label,
    required this.cost,
    required this.intervalKm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    map['vehicle_client_id'] = Variable<String>(vehicleClientId);
    map['label'] = Variable<String>(label);
    {
      map['cost'] = Variable<String>(
        $LocalMaintenanceItemsTable.$convertercost.toSql(cost),
      );
    }
    {
      map['interval_km'] = Variable<String>(
        $LocalMaintenanceItemsTable.$converterintervalKm.toSql(intervalKm),
      );
    }
    return map;
  }

  LocalMaintenanceItemsCompanion toCompanion(bool nullToAbsent) {
    return LocalMaintenanceItemsCompanion(
      clientId: Value(clientId),
      vehicleClientId: Value(vehicleClientId),
      label: Value(label),
      cost: Value(cost),
      intervalKm: Value(intervalKm),
    );
  }

  factory LocalMaintenanceItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMaintenanceItem(
      clientId: serializer.fromJson<String>(json['clientId']),
      vehicleClientId: serializer.fromJson<String>(json['vehicleClientId']),
      label: serializer.fromJson<String>(json['label']),
      cost: serializer.fromJson<Decimal>(json['cost']),
      intervalKm: serializer.fromJson<Decimal>(json['intervalKm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'vehicleClientId': serializer.toJson<String>(vehicleClientId),
      'label': serializer.toJson<String>(label),
      'cost': serializer.toJson<Decimal>(cost),
      'intervalKm': serializer.toJson<Decimal>(intervalKm),
    };
  }

  LocalMaintenanceItem copyWith({
    String? clientId,
    String? vehicleClientId,
    String? label,
    Decimal? cost,
    Decimal? intervalKm,
  }) => LocalMaintenanceItem(
    clientId: clientId ?? this.clientId,
    vehicleClientId: vehicleClientId ?? this.vehicleClientId,
    label: label ?? this.label,
    cost: cost ?? this.cost,
    intervalKm: intervalKm ?? this.intervalKm,
  );
  LocalMaintenanceItem copyWithCompanion(LocalMaintenanceItemsCompanion data) {
    return LocalMaintenanceItem(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      vehicleClientId: data.vehicleClientId.present
          ? data.vehicleClientId.value
          : this.vehicleClientId,
      label: data.label.present ? data.label.value : this.label,
      cost: data.cost.present ? data.cost.value : this.cost,
      intervalKm: data.intervalKm.present
          ? data.intervalKm.value
          : this.intervalKm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMaintenanceItem(')
          ..write('clientId: $clientId, ')
          ..write('vehicleClientId: $vehicleClientId, ')
          ..write('label: $label, ')
          ..write('cost: $cost, ')
          ..write('intervalKm: $intervalKm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(clientId, vehicleClientId, label, cost, intervalKm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMaintenanceItem &&
          other.clientId == this.clientId &&
          other.vehicleClientId == this.vehicleClientId &&
          other.label == this.label &&
          other.cost == this.cost &&
          other.intervalKm == this.intervalKm);
}

class LocalMaintenanceItemsCompanion
    extends UpdateCompanion<LocalMaintenanceItem> {
  final Value<String> clientId;
  final Value<String> vehicleClientId;
  final Value<String> label;
  final Value<Decimal> cost;
  final Value<Decimal> intervalKm;
  final Value<int> rowid;
  const LocalMaintenanceItemsCompanion({
    this.clientId = const Value.absent(),
    this.vehicleClientId = const Value.absent(),
    this.label = const Value.absent(),
    this.cost = const Value.absent(),
    this.intervalKm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMaintenanceItemsCompanion.insert({
    required String clientId,
    required String vehicleClientId,
    required String label,
    required Decimal cost,
    required Decimal intervalKm,
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       vehicleClientId = Value(vehicleClientId),
       label = Value(label),
       cost = Value(cost),
       intervalKm = Value(intervalKm);
  static Insertable<LocalMaintenanceItem> custom({
    Expression<String>? clientId,
    Expression<String>? vehicleClientId,
    Expression<String>? label,
    Expression<String>? cost,
    Expression<String>? intervalKm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (vehicleClientId != null) 'vehicle_client_id': vehicleClientId,
      if (label != null) 'label': label,
      if (cost != null) 'cost': cost,
      if (intervalKm != null) 'interval_km': intervalKm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMaintenanceItemsCompanion copyWith({
    Value<String>? clientId,
    Value<String>? vehicleClientId,
    Value<String>? label,
    Value<Decimal>? cost,
    Value<Decimal>? intervalKm,
    Value<int>? rowid,
  }) {
    return LocalMaintenanceItemsCompanion(
      clientId: clientId ?? this.clientId,
      vehicleClientId: vehicleClientId ?? this.vehicleClientId,
      label: label ?? this.label,
      cost: cost ?? this.cost,
      intervalKm: intervalKm ?? this.intervalKm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (vehicleClientId.present) {
      map['vehicle_client_id'] = Variable<String>(vehicleClientId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (cost.present) {
      map['cost'] = Variable<String>(
        $LocalMaintenanceItemsTable.$convertercost.toSql(cost.value),
      );
    }
    if (intervalKm.present) {
      map['interval_km'] = Variable<String>(
        $LocalMaintenanceItemsTable.$converterintervalKm.toSql(
          intervalKm.value,
        ),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMaintenanceItemsCompanion(')
          ..write('clientId: $clientId, ')
          ..write('vehicleClientId: $vehicleClientId, ')
          ..write('label: $label, ')
          ..write('cost: $cost, ')
          ..write('intervalKm: $intervalKm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalFixedCostsTable extends LocalFixedCosts
    with TableInfo<$LocalFixedCostsTable, LocalFixedCost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalFixedCostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleClientIdMeta = const VerificationMeta(
    'vehicleClientId',
  );
  @override
  late final GeneratedColumn<String> vehicleClientId = GeneratedColumn<String>(
    'vehicle_client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_vehicles (client_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> monthlyAmount =
      GeneratedColumn<String>(
        'monthly_amount',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalFixedCostsTable.$convertermonthlyAmount);
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    vehicleClientId,
    label,
    monthlyAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_fixed_costs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalFixedCost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('vehicle_client_id')) {
      context.handle(
        _vehicleClientIdMeta,
        vehicleClientId.isAcceptableOrUnknown(
          data['vehicle_client_id']!,
          _vehicleClientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vehicleClientIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalFixedCost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalFixedCost(
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      vehicleClientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_client_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      monthlyAmount: $LocalFixedCostsTable.$convertermonthlyAmount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}monthly_amount'],
        )!,
      ),
    );
  }

  @override
  $LocalFixedCostsTable createAlias(String alias) {
    return $LocalFixedCostsTable(attachedDatabase, alias);
  }

  static TypeConverter<Decimal, String> $convertermonthlyAmount =
      const DecimalConverter();
}

class LocalFixedCost extends DataClass implements Insertable<LocalFixedCost> {
  /// UUID gerado no dispositivo.
  final String clientId;

  /// Veículo ao qual o custo pertence.
  final String vehicleClientId;

  /// Descrição, por exemplo "IPVA".
  final String label;

  /// Valor já normalizado para o mês.
  ///
  /// A conversão de anual para mensal acontece na entrada, não na leitura:
  /// assim o rateio não precisa saber a periodicidade de cada item.
  final Decimal monthlyAmount;
  const LocalFixedCost({
    required this.clientId,
    required this.vehicleClientId,
    required this.label,
    required this.monthlyAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    map['vehicle_client_id'] = Variable<String>(vehicleClientId);
    map['label'] = Variable<String>(label);
    {
      map['monthly_amount'] = Variable<String>(
        $LocalFixedCostsTable.$convertermonthlyAmount.toSql(monthlyAmount),
      );
    }
    return map;
  }

  LocalFixedCostsCompanion toCompanion(bool nullToAbsent) {
    return LocalFixedCostsCompanion(
      clientId: Value(clientId),
      vehicleClientId: Value(vehicleClientId),
      label: Value(label),
      monthlyAmount: Value(monthlyAmount),
    );
  }

  factory LocalFixedCost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalFixedCost(
      clientId: serializer.fromJson<String>(json['clientId']),
      vehicleClientId: serializer.fromJson<String>(json['vehicleClientId']),
      label: serializer.fromJson<String>(json['label']),
      monthlyAmount: serializer.fromJson<Decimal>(json['monthlyAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'vehicleClientId': serializer.toJson<String>(vehicleClientId),
      'label': serializer.toJson<String>(label),
      'monthlyAmount': serializer.toJson<Decimal>(monthlyAmount),
    };
  }

  LocalFixedCost copyWith({
    String? clientId,
    String? vehicleClientId,
    String? label,
    Decimal? monthlyAmount,
  }) => LocalFixedCost(
    clientId: clientId ?? this.clientId,
    vehicleClientId: vehicleClientId ?? this.vehicleClientId,
    label: label ?? this.label,
    monthlyAmount: monthlyAmount ?? this.monthlyAmount,
  );
  LocalFixedCost copyWithCompanion(LocalFixedCostsCompanion data) {
    return LocalFixedCost(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      vehicleClientId: data.vehicleClientId.present
          ? data.vehicleClientId.value
          : this.vehicleClientId,
      label: data.label.present ? data.label.value : this.label,
      monthlyAmount: data.monthlyAmount.present
          ? data.monthlyAmount.value
          : this.monthlyAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalFixedCost(')
          ..write('clientId: $clientId, ')
          ..write('vehicleClientId: $vehicleClientId, ')
          ..write('label: $label, ')
          ..write('monthlyAmount: $monthlyAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(clientId, vehicleClientId, label, monthlyAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalFixedCost &&
          other.clientId == this.clientId &&
          other.vehicleClientId == this.vehicleClientId &&
          other.label == this.label &&
          other.monthlyAmount == this.monthlyAmount);
}

class LocalFixedCostsCompanion extends UpdateCompanion<LocalFixedCost> {
  final Value<String> clientId;
  final Value<String> vehicleClientId;
  final Value<String> label;
  final Value<Decimal> monthlyAmount;
  final Value<int> rowid;
  const LocalFixedCostsCompanion({
    this.clientId = const Value.absent(),
    this.vehicleClientId = const Value.absent(),
    this.label = const Value.absent(),
    this.monthlyAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalFixedCostsCompanion.insert({
    required String clientId,
    required String vehicleClientId,
    required String label,
    required Decimal monthlyAmount,
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       vehicleClientId = Value(vehicleClientId),
       label = Value(label),
       monthlyAmount = Value(monthlyAmount);
  static Insertable<LocalFixedCost> custom({
    Expression<String>? clientId,
    Expression<String>? vehicleClientId,
    Expression<String>? label,
    Expression<String>? monthlyAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (vehicleClientId != null) 'vehicle_client_id': vehicleClientId,
      if (label != null) 'label': label,
      if (monthlyAmount != null) 'monthly_amount': monthlyAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalFixedCostsCompanion copyWith({
    Value<String>? clientId,
    Value<String>? vehicleClientId,
    Value<String>? label,
    Value<Decimal>? monthlyAmount,
    Value<int>? rowid,
  }) {
    return LocalFixedCostsCompanion(
      clientId: clientId ?? this.clientId,
      vehicleClientId: vehicleClientId ?? this.vehicleClientId,
      label: label ?? this.label,
      monthlyAmount: monthlyAmount ?? this.monthlyAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (vehicleClientId.present) {
      map['vehicle_client_id'] = Variable<String>(vehicleClientId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (monthlyAmount.present) {
      map['monthly_amount'] = Variable<String>(
        $LocalFixedCostsTable.$convertermonthlyAmount.toSql(
          monthlyAmount.value,
        ),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalFixedCostsCompanion(')
          ..write('clientId: $clientId, ')
          ..write('vehicleClientId: $vehicleClientId, ')
          ..write('label: $label, ')
          ..write('monthlyAmount: $monthlyAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalWorkProfilesTable extends LocalWorkProfiles
    with TableInfo<$LocalWorkProfilesTable, LocalWorkProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalWorkProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleClientIdMeta = const VerificationMeta(
    'vehicleClientId',
  );
  @override
  late final GeneratedColumn<String> vehicleClientId = GeneratedColumn<String>(
    'vehicle_client_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> goalRsPerKm =
      GeneratedColumn<String>(
        'goal_rs_per_km',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalWorkProfilesTable.$convertergoalRsPerKm);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> goalRsPerHour =
      GeneratedColumn<String>(
        'goal_rs_per_hour',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalWorkProfilesTable.$convertergoalRsPerHour);
  static const VerificationMeta _minPassengerRatingMeta =
      const VerificationMeta('minPassengerRating');
  @override
  late final GeneratedColumn<double> minPassengerRating =
      GeneratedColumn<double>(
        'min_passenger_rating',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> maxPickupKm =
      GeneratedColumn<String>(
        'max_pickup_km',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($LocalWorkProfilesTable.$convertermaxPickupKm);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String>
  dailyRevenueGoal = GeneratedColumn<String>(
    'daily_revenue_goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Decimal>($LocalWorkProfilesTable.$converterdailyRevenueGoal);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String>
  monthlyRevenueGoal =
      GeneratedColumn<String>(
        'monthly_revenue_goal',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>(
        $LocalWorkProfilesTable.$convertermonthlyRevenueGoal,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String>
  thinkTolerancePercent =
      GeneratedColumn<String>(
        'think_tolerance_percent',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>(
        $LocalWorkProfilesTable.$converterthinkTolerancePercent,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String>
  targetMarginPercent =
      GeneratedColumn<String>(
        'target_margin_percent',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>(
        $LocalWorkProfilesTable.$convertertargetMarginPercent,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    name,
    vehicleClientId,
    goalRsPerKm,
    goalRsPerHour,
    minPassengerRating,
    maxPickupKm,
    dailyRevenueGoal,
    monthlyRevenueGoal,
    thinkTolerancePercent,
    targetMarginPercent,
    isActive,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_work_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalWorkProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('vehicle_client_id')) {
      context.handle(
        _vehicleClientIdMeta,
        vehicleClientId.isAcceptableOrUnknown(
          data['vehicle_client_id']!,
          _vehicleClientIdMeta,
        ),
      );
    }
    if (data.containsKey('min_passenger_rating')) {
      context.handle(
        _minPassengerRatingMeta,
        minPassengerRating.isAcceptableOrUnknown(
          data['min_passenger_rating']!,
          _minPassengerRatingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minPassengerRatingMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalWorkProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalWorkProfile(
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      vehicleClientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_client_id'],
      ),
      goalRsPerKm: $LocalWorkProfilesTable.$convertergoalRsPerKm.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}goal_rs_per_km'],
        )!,
      ),
      goalRsPerHour: $LocalWorkProfilesTable.$convertergoalRsPerHour.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}goal_rs_per_hour'],
        )!,
      ),
      minPassengerRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_passenger_rating'],
      )!,
      maxPickupKm: $LocalWorkProfilesTable.$convertermaxPickupKm.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}max_pickup_km'],
        )!,
      ),
      dailyRevenueGoal: $LocalWorkProfilesTable.$converterdailyRevenueGoal
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}daily_revenue_goal'],
            )!,
          ),
      monthlyRevenueGoal: $LocalWorkProfilesTable.$convertermonthlyRevenueGoal
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}monthly_revenue_goal'],
            )!,
          ),
      thinkTolerancePercent: $LocalWorkProfilesTable
          .$converterthinkTolerancePercent
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}think_tolerance_percent'],
            )!,
          ),
      targetMarginPercent: $LocalWorkProfilesTable.$convertertargetMarginPercent
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}target_margin_percent'],
            )!,
          ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LocalWorkProfilesTable createAlias(String alias) {
    return $LocalWorkProfilesTable(attachedDatabase, alias);
  }

  static TypeConverter<Decimal, String> $convertergoalRsPerKm =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $convertergoalRsPerHour =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $convertermaxPickupKm =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterdailyRevenueGoal =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $convertermonthlyRevenueGoal =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterthinkTolerancePercent =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $convertertargetMarginPercent =
      const DecimalConverter();
}

class LocalWorkProfile extends DataClass
    implements Insertable<LocalWorkProfile> {
  /// UUID gerado no dispositivo.
  final String clientId;

  /// Nome do perfil, por exemplo "Noturno".
  final String name;

  /// Veículo usado neste perfil.
  final String? vehicleClientId;

  /// Meta mínima de R$/km.
  final Decimal goalRsPerKm;

  /// Meta mínima de R$/hora.
  final Decimal goalRsPerHour;

  /// Nota mínima aceitável do passageiro.
  final double minPassengerRating;

  /// Distância máxima aceitável até o embarque.
  final Decimal maxPickupKm;

  /// Meta diária de faturamento.
  final Decimal dailyRevenueGoal;

  /// Meta mensal de faturamento.
  final Decimal monthlyRevenueGoal;

  /// Tolerância do estado "PENSE", em percentual.
  final Decimal thinkTolerancePercent;

  /// Margem desejada sobre o custo, em percentual.
  final Decimal targetMarginPercent;

  /// Perfil em uso. Só um fica ativo por vez.
  final bool isActive;

  /// Momento da última alteração.
  final DateTime updatedAt;

  /// Exclusão lógica.
  final DateTime? deletedAt;
  const LocalWorkProfile({
    required this.clientId,
    required this.name,
    this.vehicleClientId,
    required this.goalRsPerKm,
    required this.goalRsPerHour,
    required this.minPassengerRating,
    required this.maxPickupKm,
    required this.dailyRevenueGoal,
    required this.monthlyRevenueGoal,
    required this.thinkTolerancePercent,
    required this.targetMarginPercent,
    required this.isActive,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || vehicleClientId != null) {
      map['vehicle_client_id'] = Variable<String>(vehicleClientId);
    }
    {
      map['goal_rs_per_km'] = Variable<String>(
        $LocalWorkProfilesTable.$convertergoalRsPerKm.toSql(goalRsPerKm),
      );
    }
    {
      map['goal_rs_per_hour'] = Variable<String>(
        $LocalWorkProfilesTable.$convertergoalRsPerHour.toSql(goalRsPerHour),
      );
    }
    map['min_passenger_rating'] = Variable<double>(minPassengerRating);
    {
      map['max_pickup_km'] = Variable<String>(
        $LocalWorkProfilesTable.$convertermaxPickupKm.toSql(maxPickupKm),
      );
    }
    {
      map['daily_revenue_goal'] = Variable<String>(
        $LocalWorkProfilesTable.$converterdailyRevenueGoal.toSql(
          dailyRevenueGoal,
        ),
      );
    }
    {
      map['monthly_revenue_goal'] = Variable<String>(
        $LocalWorkProfilesTable.$convertermonthlyRevenueGoal.toSql(
          monthlyRevenueGoal,
        ),
      );
    }
    {
      map['think_tolerance_percent'] = Variable<String>(
        $LocalWorkProfilesTable.$converterthinkTolerancePercent.toSql(
          thinkTolerancePercent,
        ),
      );
    }
    {
      map['target_margin_percent'] = Variable<String>(
        $LocalWorkProfilesTable.$convertertargetMarginPercent.toSql(
          targetMarginPercent,
        ),
      );
    }
    map['is_active'] = Variable<bool>(isActive);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LocalWorkProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalWorkProfilesCompanion(
      clientId: Value(clientId),
      name: Value(name),
      vehicleClientId: vehicleClientId == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleClientId),
      goalRsPerKm: Value(goalRsPerKm),
      goalRsPerHour: Value(goalRsPerHour),
      minPassengerRating: Value(minPassengerRating),
      maxPickupKm: Value(maxPickupKm),
      dailyRevenueGoal: Value(dailyRevenueGoal),
      monthlyRevenueGoal: Value(monthlyRevenueGoal),
      thinkTolerancePercent: Value(thinkTolerancePercent),
      targetMarginPercent: Value(targetMarginPercent),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LocalWorkProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWorkProfile(
      clientId: serializer.fromJson<String>(json['clientId']),
      name: serializer.fromJson<String>(json['name']),
      vehicleClientId: serializer.fromJson<String?>(json['vehicleClientId']),
      goalRsPerKm: serializer.fromJson<Decimal>(json['goalRsPerKm']),
      goalRsPerHour: serializer.fromJson<Decimal>(json['goalRsPerHour']),
      minPassengerRating: serializer.fromJson<double>(
        json['minPassengerRating'],
      ),
      maxPickupKm: serializer.fromJson<Decimal>(json['maxPickupKm']),
      dailyRevenueGoal: serializer.fromJson<Decimal>(json['dailyRevenueGoal']),
      monthlyRevenueGoal: serializer.fromJson<Decimal>(
        json['monthlyRevenueGoal'],
      ),
      thinkTolerancePercent: serializer.fromJson<Decimal>(
        json['thinkTolerancePercent'],
      ),
      targetMarginPercent: serializer.fromJson<Decimal>(
        json['targetMarginPercent'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'name': serializer.toJson<String>(name),
      'vehicleClientId': serializer.toJson<String?>(vehicleClientId),
      'goalRsPerKm': serializer.toJson<Decimal>(goalRsPerKm),
      'goalRsPerHour': serializer.toJson<Decimal>(goalRsPerHour),
      'minPassengerRating': serializer.toJson<double>(minPassengerRating),
      'maxPickupKm': serializer.toJson<Decimal>(maxPickupKm),
      'dailyRevenueGoal': serializer.toJson<Decimal>(dailyRevenueGoal),
      'monthlyRevenueGoal': serializer.toJson<Decimal>(monthlyRevenueGoal),
      'thinkTolerancePercent': serializer.toJson<Decimal>(
        thinkTolerancePercent,
      ),
      'targetMarginPercent': serializer.toJson<Decimal>(targetMarginPercent),
      'isActive': serializer.toJson<bool>(isActive),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  LocalWorkProfile copyWith({
    String? clientId,
    String? name,
    Value<String?> vehicleClientId = const Value.absent(),
    Decimal? goalRsPerKm,
    Decimal? goalRsPerHour,
    double? minPassengerRating,
    Decimal? maxPickupKm,
    Decimal? dailyRevenueGoal,
    Decimal? monthlyRevenueGoal,
    Decimal? thinkTolerancePercent,
    Decimal? targetMarginPercent,
    bool? isActive,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => LocalWorkProfile(
    clientId: clientId ?? this.clientId,
    name: name ?? this.name,
    vehicleClientId: vehicleClientId.present
        ? vehicleClientId.value
        : this.vehicleClientId,
    goalRsPerKm: goalRsPerKm ?? this.goalRsPerKm,
    goalRsPerHour: goalRsPerHour ?? this.goalRsPerHour,
    minPassengerRating: minPassengerRating ?? this.minPassengerRating,
    maxPickupKm: maxPickupKm ?? this.maxPickupKm,
    dailyRevenueGoal: dailyRevenueGoal ?? this.dailyRevenueGoal,
    monthlyRevenueGoal: monthlyRevenueGoal ?? this.monthlyRevenueGoal,
    thinkTolerancePercent: thinkTolerancePercent ?? this.thinkTolerancePercent,
    targetMarginPercent: targetMarginPercent ?? this.targetMarginPercent,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LocalWorkProfile copyWithCompanion(LocalWorkProfilesCompanion data) {
    return LocalWorkProfile(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      name: data.name.present ? data.name.value : this.name,
      vehicleClientId: data.vehicleClientId.present
          ? data.vehicleClientId.value
          : this.vehicleClientId,
      goalRsPerKm: data.goalRsPerKm.present
          ? data.goalRsPerKm.value
          : this.goalRsPerKm,
      goalRsPerHour: data.goalRsPerHour.present
          ? data.goalRsPerHour.value
          : this.goalRsPerHour,
      minPassengerRating: data.minPassengerRating.present
          ? data.minPassengerRating.value
          : this.minPassengerRating,
      maxPickupKm: data.maxPickupKm.present
          ? data.maxPickupKm.value
          : this.maxPickupKm,
      dailyRevenueGoal: data.dailyRevenueGoal.present
          ? data.dailyRevenueGoal.value
          : this.dailyRevenueGoal,
      monthlyRevenueGoal: data.monthlyRevenueGoal.present
          ? data.monthlyRevenueGoal.value
          : this.monthlyRevenueGoal,
      thinkTolerancePercent: data.thinkTolerancePercent.present
          ? data.thinkTolerancePercent.value
          : this.thinkTolerancePercent,
      targetMarginPercent: data.targetMarginPercent.present
          ? data.targetMarginPercent.value
          : this.targetMarginPercent,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWorkProfile(')
          ..write('clientId: $clientId, ')
          ..write('name: $name, ')
          ..write('vehicleClientId: $vehicleClientId, ')
          ..write('goalRsPerKm: $goalRsPerKm, ')
          ..write('goalRsPerHour: $goalRsPerHour, ')
          ..write('minPassengerRating: $minPassengerRating, ')
          ..write('maxPickupKm: $maxPickupKm, ')
          ..write('dailyRevenueGoal: $dailyRevenueGoal, ')
          ..write('monthlyRevenueGoal: $monthlyRevenueGoal, ')
          ..write('thinkTolerancePercent: $thinkTolerancePercent, ')
          ..write('targetMarginPercent: $targetMarginPercent, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    name,
    vehicleClientId,
    goalRsPerKm,
    goalRsPerHour,
    minPassengerRating,
    maxPickupKm,
    dailyRevenueGoal,
    monthlyRevenueGoal,
    thinkTolerancePercent,
    targetMarginPercent,
    isActive,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalWorkProfile &&
          other.clientId == this.clientId &&
          other.name == this.name &&
          other.vehicleClientId == this.vehicleClientId &&
          other.goalRsPerKm == this.goalRsPerKm &&
          other.goalRsPerHour == this.goalRsPerHour &&
          other.minPassengerRating == this.minPassengerRating &&
          other.maxPickupKm == this.maxPickupKm &&
          other.dailyRevenueGoal == this.dailyRevenueGoal &&
          other.monthlyRevenueGoal == this.monthlyRevenueGoal &&
          other.thinkTolerancePercent == this.thinkTolerancePercent &&
          other.targetMarginPercent == this.targetMarginPercent &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class LocalWorkProfilesCompanion extends UpdateCompanion<LocalWorkProfile> {
  final Value<String> clientId;
  final Value<String> name;
  final Value<String?> vehicleClientId;
  final Value<Decimal> goalRsPerKm;
  final Value<Decimal> goalRsPerHour;
  final Value<double> minPassengerRating;
  final Value<Decimal> maxPickupKm;
  final Value<Decimal> dailyRevenueGoal;
  final Value<Decimal> monthlyRevenueGoal;
  final Value<Decimal> thinkTolerancePercent;
  final Value<Decimal> targetMarginPercent;
  final Value<bool> isActive;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const LocalWorkProfilesCompanion({
    this.clientId = const Value.absent(),
    this.name = const Value.absent(),
    this.vehicleClientId = const Value.absent(),
    this.goalRsPerKm = const Value.absent(),
    this.goalRsPerHour = const Value.absent(),
    this.minPassengerRating = const Value.absent(),
    this.maxPickupKm = const Value.absent(),
    this.dailyRevenueGoal = const Value.absent(),
    this.monthlyRevenueGoal = const Value.absent(),
    this.thinkTolerancePercent = const Value.absent(),
    this.targetMarginPercent = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWorkProfilesCompanion.insert({
    required String clientId,
    required String name,
    this.vehicleClientId = const Value.absent(),
    required Decimal goalRsPerKm,
    required Decimal goalRsPerHour,
    required double minPassengerRating,
    required Decimal maxPickupKm,
    required Decimal dailyRevenueGoal,
    required Decimal monthlyRevenueGoal,
    required Decimal thinkTolerancePercent,
    required Decimal targetMarginPercent,
    this.isActive = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       name = Value(name),
       goalRsPerKm = Value(goalRsPerKm),
       goalRsPerHour = Value(goalRsPerHour),
       minPassengerRating = Value(minPassengerRating),
       maxPickupKm = Value(maxPickupKm),
       dailyRevenueGoal = Value(dailyRevenueGoal),
       monthlyRevenueGoal = Value(monthlyRevenueGoal),
       thinkTolerancePercent = Value(thinkTolerancePercent),
       targetMarginPercent = Value(targetMarginPercent),
       updatedAt = Value(updatedAt);
  static Insertable<LocalWorkProfile> custom({
    Expression<String>? clientId,
    Expression<String>? name,
    Expression<String>? vehicleClientId,
    Expression<String>? goalRsPerKm,
    Expression<String>? goalRsPerHour,
    Expression<double>? minPassengerRating,
    Expression<String>? maxPickupKm,
    Expression<String>? dailyRevenueGoal,
    Expression<String>? monthlyRevenueGoal,
    Expression<String>? thinkTolerancePercent,
    Expression<String>? targetMarginPercent,
    Expression<bool>? isActive,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (name != null) 'name': name,
      if (vehicleClientId != null) 'vehicle_client_id': vehicleClientId,
      if (goalRsPerKm != null) 'goal_rs_per_km': goalRsPerKm,
      if (goalRsPerHour != null) 'goal_rs_per_hour': goalRsPerHour,
      if (minPassengerRating != null)
        'min_passenger_rating': minPassengerRating,
      if (maxPickupKm != null) 'max_pickup_km': maxPickupKm,
      if (dailyRevenueGoal != null) 'daily_revenue_goal': dailyRevenueGoal,
      if (monthlyRevenueGoal != null)
        'monthly_revenue_goal': monthlyRevenueGoal,
      if (thinkTolerancePercent != null)
        'think_tolerance_percent': thinkTolerancePercent,
      if (targetMarginPercent != null)
        'target_margin_percent': targetMarginPercent,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWorkProfilesCompanion copyWith({
    Value<String>? clientId,
    Value<String>? name,
    Value<String?>? vehicleClientId,
    Value<Decimal>? goalRsPerKm,
    Value<Decimal>? goalRsPerHour,
    Value<double>? minPassengerRating,
    Value<Decimal>? maxPickupKm,
    Value<Decimal>? dailyRevenueGoal,
    Value<Decimal>? monthlyRevenueGoal,
    Value<Decimal>? thinkTolerancePercent,
    Value<Decimal>? targetMarginPercent,
    Value<bool>? isActive,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LocalWorkProfilesCompanion(
      clientId: clientId ?? this.clientId,
      name: name ?? this.name,
      vehicleClientId: vehicleClientId ?? this.vehicleClientId,
      goalRsPerKm: goalRsPerKm ?? this.goalRsPerKm,
      goalRsPerHour: goalRsPerHour ?? this.goalRsPerHour,
      minPassengerRating: minPassengerRating ?? this.minPassengerRating,
      maxPickupKm: maxPickupKm ?? this.maxPickupKm,
      dailyRevenueGoal: dailyRevenueGoal ?? this.dailyRevenueGoal,
      monthlyRevenueGoal: monthlyRevenueGoal ?? this.monthlyRevenueGoal,
      thinkTolerancePercent:
          thinkTolerancePercent ?? this.thinkTolerancePercent,
      targetMarginPercent: targetMarginPercent ?? this.targetMarginPercent,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (vehicleClientId.present) {
      map['vehicle_client_id'] = Variable<String>(vehicleClientId.value);
    }
    if (goalRsPerKm.present) {
      map['goal_rs_per_km'] = Variable<String>(
        $LocalWorkProfilesTable.$convertergoalRsPerKm.toSql(goalRsPerKm.value),
      );
    }
    if (goalRsPerHour.present) {
      map['goal_rs_per_hour'] = Variable<String>(
        $LocalWorkProfilesTable.$convertergoalRsPerHour.toSql(
          goalRsPerHour.value,
        ),
      );
    }
    if (minPassengerRating.present) {
      map['min_passenger_rating'] = Variable<double>(minPassengerRating.value);
    }
    if (maxPickupKm.present) {
      map['max_pickup_km'] = Variable<String>(
        $LocalWorkProfilesTable.$convertermaxPickupKm.toSql(maxPickupKm.value),
      );
    }
    if (dailyRevenueGoal.present) {
      map['daily_revenue_goal'] = Variable<String>(
        $LocalWorkProfilesTable.$converterdailyRevenueGoal.toSql(
          dailyRevenueGoal.value,
        ),
      );
    }
    if (monthlyRevenueGoal.present) {
      map['monthly_revenue_goal'] = Variable<String>(
        $LocalWorkProfilesTable.$convertermonthlyRevenueGoal.toSql(
          monthlyRevenueGoal.value,
        ),
      );
    }
    if (thinkTolerancePercent.present) {
      map['think_tolerance_percent'] = Variable<String>(
        $LocalWorkProfilesTable.$converterthinkTolerancePercent.toSql(
          thinkTolerancePercent.value,
        ),
      );
    }
    if (targetMarginPercent.present) {
      map['target_margin_percent'] = Variable<String>(
        $LocalWorkProfilesTable.$convertertargetMarginPercent.toSql(
          targetMarginPercent.value,
        ),
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalWorkProfilesCompanion(')
          ..write('clientId: $clientId, ')
          ..write('name: $name, ')
          ..write('vehicleClientId: $vehicleClientId, ')
          ..write('goalRsPerKm: $goalRsPerKm, ')
          ..write('goalRsPerHour: $goalRsPerHour, ')
          ..write('minPassengerRating: $minPassengerRating, ')
          ..write('maxPickupKm: $maxPickupKm, ')
          ..write('dailyRevenueGoal: $dailyRevenueGoal, ')
          ..write('monthlyRevenueGoal: $monthlyRevenueGoal, ')
          ..write('thinkTolerancePercent: $thinkTolerancePercent, ')
          ..write('targetMarginPercent: $targetMarginPercent, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalRideEvaluationsTable localRideEvaluations =
      $LocalRideEvaluationsTable(this);
  late final $LocalExpensesTable localExpenses = $LocalExpensesTable(this);
  late final $LocalWorkSessionsTable localWorkSessions =
      $LocalWorkSessionsTable(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final $LocalVehiclesTable localVehicles = $LocalVehiclesTable(this);
  late final $LocalMaintenanceItemsTable localMaintenanceItems =
      $LocalMaintenanceItemsTable(this);
  late final $LocalFixedCostsTable localFixedCosts = $LocalFixedCostsTable(
    this,
  );
  late final $LocalWorkProfilesTable localWorkProfiles =
      $LocalWorkProfilesTable(this);
  late final RideDao rideDao = RideDao(this as AppDatabase);
  late final ExpenseDao expenseDao = ExpenseDao(this as AppDatabase);
  late final OutboxDao outboxDao = OutboxDao(this as AppDatabase);
  late final ConfigDao configDao = ConfigDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localRideEvaluations,
    localExpenses,
    localWorkSessions,
    outboxEntries,
    localVehicles,
    localMaintenanceItems,
    localFixedCosts,
    localWorkProfiles,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('local_maintenance_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('local_fixed_costs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LocalRideEvaluationsTableCreateCompanionBuilder =
    LocalRideEvaluationsCompanion Function({
      required String clientId,
      required RidePlatform platform,
      required DateTime occurredAt,
      required Decimal fare,
      required Decimal pickupKm,
      required Decimal tripKm,
      Value<double> pickupMinutes,
      Value<double> tripMinutes,
      Value<double?> passengerRating,
      Value<String?> pickupRegion,
      Value<Decimal?> surgeMultiplier,
      required Decimal rsPerKm,
      required Decimal rsPerHour,
      required Decimal costPerKmUsed,
      required Decimal operatingCost,
      required Decimal realProfit,
      Value<Decimal?> marginPercent,
      required RideVerdict verdict,
      required RideOutcome outcome,
      Value<String?> workSessionClientId,
      Value<int> rowid,
    });
typedef $$LocalRideEvaluationsTableUpdateCompanionBuilder =
    LocalRideEvaluationsCompanion Function({
      Value<String> clientId,
      Value<RidePlatform> platform,
      Value<DateTime> occurredAt,
      Value<Decimal> fare,
      Value<Decimal> pickupKm,
      Value<Decimal> tripKm,
      Value<double> pickupMinutes,
      Value<double> tripMinutes,
      Value<double?> passengerRating,
      Value<String?> pickupRegion,
      Value<Decimal?> surgeMultiplier,
      Value<Decimal> rsPerKm,
      Value<Decimal> rsPerHour,
      Value<Decimal> costPerKmUsed,
      Value<Decimal> operatingCost,
      Value<Decimal> realProfit,
      Value<Decimal?> marginPercent,
      Value<RideVerdict> verdict,
      Value<RideOutcome> outcome,
      Value<String?> workSessionClientId,
      Value<int> rowid,
    });

class $$LocalRideEvaluationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalRideEvaluationsTable> {
  $$LocalRideEvaluationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RidePlatform, RidePlatform, String>
  get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get fare =>
      $composableBuilder(
        column: $table.fare,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get pickupKm =>
      $composableBuilder(
        column: $table.pickupKm,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get tripKm =>
      $composableBuilder(
        column: $table.tripKm,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get pickupMinutes => $composableBuilder(
    column: $table.pickupMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tripMinutes => $composableBuilder(
    column: $table.tripMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get passengerRating => $composableBuilder(
    column: $table.passengerRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pickupRegion => $composableBuilder(
    column: $table.pickupRegion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String>
  get surgeMultiplier => $composableBuilder(
    column: $table.surgeMultiplier,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get rsPerKm =>
      $composableBuilder(
        column: $table.rsPerKm,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get rsPerHour =>
      $composableBuilder(
        column: $table.rsPerHour,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get costPerKmUsed =>
      $composableBuilder(
        column: $table.costPerKmUsed,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get operatingCost =>
      $composableBuilder(
        column: $table.operatingCost,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get realProfit =>
      $composableBuilder(
        column: $table.realProfit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String> get marginPercent =>
      $composableBuilder(
        column: $table.marginPercent,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<RideVerdict, RideVerdict, String>
  get verdict => $composableBuilder(
    column: $table.verdict,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<RideOutcome, RideOutcome, String>
  get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get workSessionClientId => $composableBuilder(
    column: $table.workSessionClientId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalRideEvaluationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalRideEvaluationsTable> {
  $$LocalRideEvaluationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fare => $composableBuilder(
    column: $table.fare,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pickupKm => $composableBuilder(
    column: $table.pickupKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripKm => $composableBuilder(
    column: $table.tripKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pickupMinutes => $composableBuilder(
    column: $table.pickupMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tripMinutes => $composableBuilder(
    column: $table.tripMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get passengerRating => $composableBuilder(
    column: $table.passengerRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pickupRegion => $composableBuilder(
    column: $table.pickupRegion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surgeMultiplier => $composableBuilder(
    column: $table.surgeMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rsPerKm => $composableBuilder(
    column: $table.rsPerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rsPerHour => $composableBuilder(
    column: $table.rsPerHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get costPerKmUsed => $composableBuilder(
    column: $table.costPerKmUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operatingCost => $composableBuilder(
    column: $table.operatingCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get realProfit => $composableBuilder(
    column: $table.realProfit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marginPercent => $composableBuilder(
    column: $table.marginPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verdict => $composableBuilder(
    column: $table.verdict,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workSessionClientId => $composableBuilder(
    column: $table.workSessionClientId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalRideEvaluationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalRideEvaluationsTable> {
  $$LocalRideEvaluationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RidePlatform, String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Decimal, String> get fare =>
      $composableBuilder(column: $table.fare, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get pickupKm =>
      $composableBuilder(column: $table.pickupKm, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get tripKm =>
      $composableBuilder(column: $table.tripKm, builder: (column) => column);

  GeneratedColumn<double> get pickupMinutes => $composableBuilder(
    column: $table.pickupMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tripMinutes => $composableBuilder(
    column: $table.tripMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get passengerRating => $composableBuilder(
    column: $table.passengerRating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pickupRegion => $composableBuilder(
    column: $table.pickupRegion,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Decimal?, String> get surgeMultiplier =>
      $composableBuilder(
        column: $table.surgeMultiplier,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal, String> get rsPerKm =>
      $composableBuilder(column: $table.rsPerKm, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get rsPerHour =>
      $composableBuilder(column: $table.rsPerHour, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get costPerKmUsed =>
      $composableBuilder(
        column: $table.costPerKmUsed,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal, String> get operatingCost =>
      $composableBuilder(
        column: $table.operatingCost,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal, String> get realProfit =>
      $composableBuilder(
        column: $table.realProfit,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal?, String> get marginPercent =>
      $composableBuilder(
        column: $table.marginPercent,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<RideVerdict, String> get verdict =>
      $composableBuilder(column: $table.verdict, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RideOutcome, String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<String> get workSessionClientId => $composableBuilder(
    column: $table.workSessionClientId,
    builder: (column) => column,
  );
}

class $$LocalRideEvaluationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalRideEvaluationsTable,
          LocalRide,
          $$LocalRideEvaluationsTableFilterComposer,
          $$LocalRideEvaluationsTableOrderingComposer,
          $$LocalRideEvaluationsTableAnnotationComposer,
          $$LocalRideEvaluationsTableCreateCompanionBuilder,
          $$LocalRideEvaluationsTableUpdateCompanionBuilder,
          (
            LocalRide,
            BaseReferences<
              _$AppDatabase,
              $LocalRideEvaluationsTable,
              LocalRide
            >,
          ),
          LocalRide,
          PrefetchHooks Function()
        > {
  $$LocalRideEvaluationsTableTableManager(
    _$AppDatabase db,
    $LocalRideEvaluationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalRideEvaluationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalRideEvaluationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalRideEvaluationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<RidePlatform> platform = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<Decimal> fare = const Value.absent(),
                Value<Decimal> pickupKm = const Value.absent(),
                Value<Decimal> tripKm = const Value.absent(),
                Value<double> pickupMinutes = const Value.absent(),
                Value<double> tripMinutes = const Value.absent(),
                Value<double?> passengerRating = const Value.absent(),
                Value<String?> pickupRegion = const Value.absent(),
                Value<Decimal?> surgeMultiplier = const Value.absent(),
                Value<Decimal> rsPerKm = const Value.absent(),
                Value<Decimal> rsPerHour = const Value.absent(),
                Value<Decimal> costPerKmUsed = const Value.absent(),
                Value<Decimal> operatingCost = const Value.absent(),
                Value<Decimal> realProfit = const Value.absent(),
                Value<Decimal?> marginPercent = const Value.absent(),
                Value<RideVerdict> verdict = const Value.absent(),
                Value<RideOutcome> outcome = const Value.absent(),
                Value<String?> workSessionClientId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalRideEvaluationsCompanion(
                clientId: clientId,
                platform: platform,
                occurredAt: occurredAt,
                fare: fare,
                pickupKm: pickupKm,
                tripKm: tripKm,
                pickupMinutes: pickupMinutes,
                tripMinutes: tripMinutes,
                passengerRating: passengerRating,
                pickupRegion: pickupRegion,
                surgeMultiplier: surgeMultiplier,
                rsPerKm: rsPerKm,
                rsPerHour: rsPerHour,
                costPerKmUsed: costPerKmUsed,
                operatingCost: operatingCost,
                realProfit: realProfit,
                marginPercent: marginPercent,
                verdict: verdict,
                outcome: outcome,
                workSessionClientId: workSessionClientId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                required RidePlatform platform,
                required DateTime occurredAt,
                required Decimal fare,
                required Decimal pickupKm,
                required Decimal tripKm,
                Value<double> pickupMinutes = const Value.absent(),
                Value<double> tripMinutes = const Value.absent(),
                Value<double?> passengerRating = const Value.absent(),
                Value<String?> pickupRegion = const Value.absent(),
                Value<Decimal?> surgeMultiplier = const Value.absent(),
                required Decimal rsPerKm,
                required Decimal rsPerHour,
                required Decimal costPerKmUsed,
                required Decimal operatingCost,
                required Decimal realProfit,
                Value<Decimal?> marginPercent = const Value.absent(),
                required RideVerdict verdict,
                required RideOutcome outcome,
                Value<String?> workSessionClientId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalRideEvaluationsCompanion.insert(
                clientId: clientId,
                platform: platform,
                occurredAt: occurredAt,
                fare: fare,
                pickupKm: pickupKm,
                tripKm: tripKm,
                pickupMinutes: pickupMinutes,
                tripMinutes: tripMinutes,
                passengerRating: passengerRating,
                pickupRegion: pickupRegion,
                surgeMultiplier: surgeMultiplier,
                rsPerKm: rsPerKm,
                rsPerHour: rsPerHour,
                costPerKmUsed: costPerKmUsed,
                operatingCost: operatingCost,
                realProfit: realProfit,
                marginPercent: marginPercent,
                verdict: verdict,
                outcome: outcome,
                workSessionClientId: workSessionClientId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalRideEvaluationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalRideEvaluationsTable,
      LocalRide,
      $$LocalRideEvaluationsTableFilterComposer,
      $$LocalRideEvaluationsTableOrderingComposer,
      $$LocalRideEvaluationsTableAnnotationComposer,
      $$LocalRideEvaluationsTableCreateCompanionBuilder,
      $$LocalRideEvaluationsTableUpdateCompanionBuilder,
      (
        LocalRide,
        BaseReferences<_$AppDatabase, $LocalRideEvaluationsTable, LocalRide>,
      ),
      LocalRide,
      PrefetchHooks Function()
    >;
typedef $$LocalExpensesTableCreateCompanionBuilder =
    LocalExpensesCompanion Function({
      required String clientId,
      required ExpenseCategory category,
      required Decimal amount,
      Value<Decimal?> liters,
      Value<Decimal?> odometerKm,
      Value<String?> description,
      required DateTime occurredAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> workSessionClientId,
      Value<int> rowid,
    });
typedef $$LocalExpensesTableUpdateCompanionBuilder =
    LocalExpensesCompanion Function({
      Value<String> clientId,
      Value<ExpenseCategory> category,
      Value<Decimal> amount,
      Value<Decimal?> liters,
      Value<Decimal?> odometerKm,
      Value<String?> description,
      Value<DateTime> occurredAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> workSessionClientId,
      Value<int> rowid,
    });

class $$LocalExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExpenseCategory, ExpenseCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String> get liters =>
      $composableBuilder(
        column: $table.liters,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String> get odometerKm =>
      $composableBuilder(
        column: $table.odometerKm,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workSessionClientId => $composableBuilder(
    column: $table.workSessionClientId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workSessionClientId => $composableBuilder(
    column: $table.workSessionClientId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExpenseCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal?, String> get liters =>
      $composableBuilder(column: $table.liters, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal?, String> get odometerKm =>
      $composableBuilder(
        column: $table.odometerKm,
        builder: (column) => column,
      );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get workSessionClientId => $composableBuilder(
    column: $table.workSessionClientId,
    builder: (column) => column,
  );
}

class $$LocalExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalExpensesTable,
          LocalExpense,
          $$LocalExpensesTableFilterComposer,
          $$LocalExpensesTableOrderingComposer,
          $$LocalExpensesTableAnnotationComposer,
          $$LocalExpensesTableCreateCompanionBuilder,
          $$LocalExpensesTableUpdateCompanionBuilder,
          (
            LocalExpense,
            BaseReferences<_$AppDatabase, $LocalExpensesTable, LocalExpense>,
          ),
          LocalExpense,
          PrefetchHooks Function()
        > {
  $$LocalExpensesTableTableManager(_$AppDatabase db, $LocalExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<ExpenseCategory> category = const Value.absent(),
                Value<Decimal> amount = const Value.absent(),
                Value<Decimal?> liters = const Value.absent(),
                Value<Decimal?> odometerKm = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> workSessionClientId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExpensesCompanion(
                clientId: clientId,
                category: category,
                amount: amount,
                liters: liters,
                odometerKm: odometerKm,
                description: description,
                occurredAt: occurredAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                workSessionClientId: workSessionClientId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                required ExpenseCategory category,
                required Decimal amount,
                Value<Decimal?> liters = const Value.absent(),
                Value<Decimal?> odometerKm = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required DateTime occurredAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> workSessionClientId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExpensesCompanion.insert(
                clientId: clientId,
                category: category,
                amount: amount,
                liters: liters,
                odometerKm: odometerKm,
                description: description,
                occurredAt: occurredAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                workSessionClientId: workSessionClientId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalExpensesTable,
      LocalExpense,
      $$LocalExpensesTableFilterComposer,
      $$LocalExpensesTableOrderingComposer,
      $$LocalExpensesTableAnnotationComposer,
      $$LocalExpensesTableCreateCompanionBuilder,
      $$LocalExpensesTableUpdateCompanionBuilder,
      (
        LocalExpense,
        BaseReferences<_$AppDatabase, $LocalExpensesTable, LocalExpense>,
      ),
      LocalExpense,
      PrefetchHooks Function()
    >;
typedef $$LocalWorkSessionsTableCreateCompanionBuilder =
    LocalWorkSessionsCompanion Function({
      required String clientId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> rowid,
    });
typedef $$LocalWorkSessionsTableUpdateCompanionBuilder =
    LocalWorkSessionsCompanion Function({
      Value<String> clientId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> rowid,
    });

class $$LocalWorkSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalWorkSessionsTable> {
  $$LocalWorkSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalWorkSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalWorkSessionsTable> {
  $$LocalWorkSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalWorkSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalWorkSessionsTable> {
  $$LocalWorkSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);
}

class $$LocalWorkSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalWorkSessionsTable,
          LocalWorkSession,
          $$LocalWorkSessionsTableFilterComposer,
          $$LocalWorkSessionsTableOrderingComposer,
          $$LocalWorkSessionsTableAnnotationComposer,
          $$LocalWorkSessionsTableCreateCompanionBuilder,
          $$LocalWorkSessionsTableUpdateCompanionBuilder,
          (
            LocalWorkSession,
            BaseReferences<
              _$AppDatabase,
              $LocalWorkSessionsTable,
              LocalWorkSession
            >,
          ),
          LocalWorkSession,
          PrefetchHooks Function()
        > {
  $$LocalWorkSessionsTableTableManager(
    _$AppDatabase db,
    $LocalWorkSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalWorkSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalWorkSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalWorkSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWorkSessionsCompanion(
                clientId: clientId,
                startedAt: startedAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWorkSessionsCompanion.insert(
                clientId: clientId,
                startedAt: startedAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalWorkSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalWorkSessionsTable,
      LocalWorkSession,
      $$LocalWorkSessionsTableFilterComposer,
      $$LocalWorkSessionsTableOrderingComposer,
      $$LocalWorkSessionsTableAnnotationComposer,
      $$LocalWorkSessionsTableCreateCompanionBuilder,
      $$LocalWorkSessionsTableUpdateCompanionBuilder,
      (
        LocalWorkSession,
        BaseReferences<
          _$AppDatabase,
          $LocalWorkSessionsTable,
          LocalWorkSession
        >,
      ),
      LocalWorkSession,
      PrefetchHooks Function()
    >;
typedef $$OutboxEntriesTableCreateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      required OutboxKind kind,
      required String entityClientId,
      required DateTime createdAt,
      Value<int> attempts,
      Value<String?> lastError,
    });
typedef $$OutboxEntriesTableUpdateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      Value<OutboxKind> kind,
      Value<String> entityClientId,
      Value<DateTime> createdAt,
      Value<int> attempts,
      Value<String?> lastError,
    });

class $$OutboxEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OutboxKind, OutboxKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get entityClientId => $composableBuilder(
    column: $table.entityClientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityClientId => $composableBuilder(
    column: $table.entityClientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OutboxKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get entityClientId => $composableBuilder(
    column: $table.entityClientId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$OutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxEntriesTable,
          OutboxEntry,
          $$OutboxEntriesTableFilterComposer,
          $$OutboxEntriesTableOrderingComposer,
          $$OutboxEntriesTableAnnotationComposer,
          $$OutboxEntriesTableCreateCompanionBuilder,
          $$OutboxEntriesTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxEntriesTableTableManager(_$AppDatabase db, $OutboxEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<OutboxKind> kind = const Value.absent(),
                Value<String> entityClientId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => OutboxEntriesCompanion(
                id: id,
                kind: kind,
                entityClientId: entityClientId,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required OutboxKind kind,
                required String entityClientId,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => OutboxEntriesCompanion.insert(
                id: id,
                kind: kind,
                entityClientId: entityClientId,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxEntriesTable,
      OutboxEntry,
      $$OutboxEntriesTableFilterComposer,
      $$OutboxEntriesTableOrderingComposer,
      $$OutboxEntriesTableAnnotationComposer,
      $$OutboxEntriesTableCreateCompanionBuilder,
      $$OutboxEntriesTableUpdateCompanionBuilder,
      (
        OutboxEntry,
        BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
      ),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$LocalVehiclesTableCreateCompanionBuilder =
    LocalVehiclesCompanion Function({
      required String clientId,
      required String nickname,
      Value<String?> make,
      Value<String?> model,
      Value<int?> modelYear,
      Value<String?> plateSuffix,
      required FuelType fuel,
      required Decimal consumption,
      required Decimal fuelPrice,
      Value<Decimal?> marketValue,
      required Decimal depreciationPerKm,
      required Decimal genericMaintenancePerKm,
      required int workDaysPerMonth,
      required Decimal kmPerDay,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$LocalVehiclesTableUpdateCompanionBuilder =
    LocalVehiclesCompanion Function({
      Value<String> clientId,
      Value<String> nickname,
      Value<String?> make,
      Value<String?> model,
      Value<int?> modelYear,
      Value<String?> plateSuffix,
      Value<FuelType> fuel,
      Value<Decimal> consumption,
      Value<Decimal> fuelPrice,
      Value<Decimal?> marketValue,
      Value<Decimal> depreciationPerKm,
      Value<Decimal> genericMaintenancePerKm,
      Value<int> workDaysPerMonth,
      Value<Decimal> kmPerDay,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$LocalVehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $LocalVehiclesTable, LocalVehicle> {
  $$LocalVehiclesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $LocalMaintenanceItemsTable,
    List<LocalMaintenanceItem>
  >
  _localMaintenanceItemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.localMaintenanceItems,
    aliasName:
        'local_vehicles__client_id__local_maintenance_items__vehicle_client_id',
  );

  $$LocalMaintenanceItemsTableProcessedTableManager
  get localMaintenanceItemsRefs {
    final manager =
        $$LocalMaintenanceItemsTableTableManager(
          $_db,
          $_db.localMaintenanceItems,
        ).filter(
          (f) => f.vehicleClientId.clientId.sqlEquals(
            $_itemColumn<String>('client_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _localMaintenanceItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LocalFixedCostsTable, List<LocalFixedCost>>
  _localFixedCostsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.localFixedCosts,
    aliasName:
        'local_vehicles__client_id__local_fixed_costs__vehicle_client_id',
  );

  $$LocalFixedCostsTableProcessedTableManager get localFixedCostsRefs {
    final manager =
        $$LocalFixedCostsTableTableManager($_db, $_db.localFixedCosts).filter(
          (f) => f.vehicleClientId.clientId.sqlEquals(
            $_itemColumn<String>('client_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _localFixedCostsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocalVehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVehiclesTable> {
  $$LocalVehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get modelYear => $composableBuilder(
    column: $table.modelYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plateSuffix => $composableBuilder(
    column: $table.plateSuffix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FuelType, FuelType, String> get fuel =>
      $composableBuilder(
        column: $table.fuel,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get consumption =>
      $composableBuilder(
        column: $table.consumption,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get fuelPrice =>
      $composableBuilder(
        column: $table.fuelPrice,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String> get marketValue =>
      $composableBuilder(
        column: $table.marketValue,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String>
  get depreciationPerKm => $composableBuilder(
    column: $table.depreciationPerKm,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String>
  get genericMaintenancePerKm => $composableBuilder(
    column: $table.genericMaintenancePerKm,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get workDaysPerMonth => $composableBuilder(
    column: $table.workDaysPerMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get kmPerDay =>
      $composableBuilder(
        column: $table.kmPerDay,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> localMaintenanceItemsRefs(
    Expression<bool> Function($$LocalMaintenanceItemsTableFilterComposer f) f,
  ) {
    final $$LocalMaintenanceItemsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.clientId,
          referencedTable: $db.localMaintenanceItems,
          getReferencedColumn: (t) => t.vehicleClientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LocalMaintenanceItemsTableFilterComposer(
                $db: $db,
                $table: $db.localMaintenanceItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> localFixedCostsRefs(
    Expression<bool> Function($$LocalFixedCostsTableFilterComposer f) f,
  ) {
    final $$LocalFixedCostsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.localFixedCosts,
      getReferencedColumn: (t) => t.vehicleClientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalFixedCostsTableFilterComposer(
            $db: $db,
            $table: $db.localFixedCosts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalVehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVehiclesTable> {
  $$LocalVehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get modelYear => $composableBuilder(
    column: $table.modelYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plateSuffix => $composableBuilder(
    column: $table.plateSuffix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuel => $composableBuilder(
    column: $table.fuel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get consumption => $composableBuilder(
    column: $table.consumption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelPrice => $composableBuilder(
    column: $table.fuelPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marketValue => $composableBuilder(
    column: $table.marketValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get depreciationPerKm => $composableBuilder(
    column: $table.depreciationPerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genericMaintenancePerKm => $composableBuilder(
    column: $table.genericMaintenancePerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workDaysPerMonth => $composableBuilder(
    column: $table.workDaysPerMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kmPerDay => $composableBuilder(
    column: $table.kmPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVehiclesTable> {
  $$LocalVehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get make =>
      $composableBuilder(column: $table.make, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get modelYear =>
      $composableBuilder(column: $table.modelYear, builder: (column) => column);

  GeneratedColumn<String> get plateSuffix => $composableBuilder(
    column: $table.plateSuffix,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FuelType, String> get fuel =>
      $composableBuilder(column: $table.fuel, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get consumption =>
      $composableBuilder(
        column: $table.consumption,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal, String> get fuelPrice =>
      $composableBuilder(column: $table.fuelPrice, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal?, String> get marketValue =>
      $composableBuilder(
        column: $table.marketValue,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal, String> get depreciationPerKm =>
      $composableBuilder(
        column: $table.depreciationPerKm,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal, String>
  get genericMaintenancePerKm => $composableBuilder(
    column: $table.genericMaintenancePerKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get workDaysPerMonth => $composableBuilder(
    column: $table.workDaysPerMonth,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Decimal, String> get kmPerDay =>
      $composableBuilder(column: $table.kmPerDay, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> localMaintenanceItemsRefs<T extends Object>(
    Expression<T> Function($$LocalMaintenanceItemsTableAnnotationComposer a) f,
  ) {
    final $$LocalMaintenanceItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.clientId,
          referencedTable: $db.localMaintenanceItems,
          getReferencedColumn: (t) => t.vehicleClientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LocalMaintenanceItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.localMaintenanceItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> localFixedCostsRefs<T extends Object>(
    Expression<T> Function($$LocalFixedCostsTableAnnotationComposer a) f,
  ) {
    final $$LocalFixedCostsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.localFixedCosts,
      getReferencedColumn: (t) => t.vehicleClientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalFixedCostsTableAnnotationComposer(
            $db: $db,
            $table: $db.localFixedCosts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalVehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVehiclesTable,
          LocalVehicle,
          $$LocalVehiclesTableFilterComposer,
          $$LocalVehiclesTableOrderingComposer,
          $$LocalVehiclesTableAnnotationComposer,
          $$LocalVehiclesTableCreateCompanionBuilder,
          $$LocalVehiclesTableUpdateCompanionBuilder,
          (LocalVehicle, $$LocalVehiclesTableReferences),
          LocalVehicle,
          PrefetchHooks Function({
            bool localMaintenanceItemsRefs,
            bool localFixedCostsRefs,
          })
        > {
  $$LocalVehiclesTableTableManager(_$AppDatabase db, $LocalVehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalVehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalVehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String?> make = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<int?> modelYear = const Value.absent(),
                Value<String?> plateSuffix = const Value.absent(),
                Value<FuelType> fuel = const Value.absent(),
                Value<Decimal> consumption = const Value.absent(),
                Value<Decimal> fuelPrice = const Value.absent(),
                Value<Decimal?> marketValue = const Value.absent(),
                Value<Decimal> depreciationPerKm = const Value.absent(),
                Value<Decimal> genericMaintenancePerKm = const Value.absent(),
                Value<int> workDaysPerMonth = const Value.absent(),
                Value<Decimal> kmPerDay = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVehiclesCompanion(
                clientId: clientId,
                nickname: nickname,
                make: make,
                model: model,
                modelYear: modelYear,
                plateSuffix: plateSuffix,
                fuel: fuel,
                consumption: consumption,
                fuelPrice: fuelPrice,
                marketValue: marketValue,
                depreciationPerKm: depreciationPerKm,
                genericMaintenancePerKm: genericMaintenancePerKm,
                workDaysPerMonth: workDaysPerMonth,
                kmPerDay: kmPerDay,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                required String nickname,
                Value<String?> make = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<int?> modelYear = const Value.absent(),
                Value<String?> plateSuffix = const Value.absent(),
                required FuelType fuel,
                required Decimal consumption,
                required Decimal fuelPrice,
                Value<Decimal?> marketValue = const Value.absent(),
                required Decimal depreciationPerKm,
                required Decimal genericMaintenancePerKm,
                required int workDaysPerMonth,
                required Decimal kmPerDay,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVehiclesCompanion.insert(
                clientId: clientId,
                nickname: nickname,
                make: make,
                model: model,
                modelYear: modelYear,
                plateSuffix: plateSuffix,
                fuel: fuel,
                consumption: consumption,
                fuelPrice: fuelPrice,
                marketValue: marketValue,
                depreciationPerKm: depreciationPerKm,
                genericMaintenancePerKm: genericMaintenancePerKm,
                workDaysPerMonth: workDaysPerMonth,
                kmPerDay: kmPerDay,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalVehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                localMaintenanceItemsRefs = false,
                localFixedCostsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (localMaintenanceItemsRefs) db.localMaintenanceItems,
                    if (localFixedCostsRefs) db.localFixedCosts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (localMaintenanceItemsRefs)
                        await $_getPrefetchedData<
                          LocalVehicle,
                          $LocalVehiclesTable,
                          LocalMaintenanceItem
                        >(
                          currentTable: table,
                          referencedTable: $$LocalVehiclesTableReferences
                              ._localMaintenanceItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalVehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).localMaintenanceItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleClientId == item.clientId,
                              ),
                          typedResults: items,
                        ),
                      if (localFixedCostsRefs)
                        await $_getPrefetchedData<
                          LocalVehicle,
                          $LocalVehiclesTable,
                          LocalFixedCost
                        >(
                          currentTable: table,
                          referencedTable: $$LocalVehiclesTableReferences
                              ._localFixedCostsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalVehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).localFixedCostsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleClientId == item.clientId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LocalVehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVehiclesTable,
      LocalVehicle,
      $$LocalVehiclesTableFilterComposer,
      $$LocalVehiclesTableOrderingComposer,
      $$LocalVehiclesTableAnnotationComposer,
      $$LocalVehiclesTableCreateCompanionBuilder,
      $$LocalVehiclesTableUpdateCompanionBuilder,
      (LocalVehicle, $$LocalVehiclesTableReferences),
      LocalVehicle,
      PrefetchHooks Function({
        bool localMaintenanceItemsRefs,
        bool localFixedCostsRefs,
      })
    >;
typedef $$LocalMaintenanceItemsTableCreateCompanionBuilder =
    LocalMaintenanceItemsCompanion Function({
      required String clientId,
      required String vehicleClientId,
      required String label,
      required Decimal cost,
      required Decimal intervalKm,
      Value<int> rowid,
    });
typedef $$LocalMaintenanceItemsTableUpdateCompanionBuilder =
    LocalMaintenanceItemsCompanion Function({
      Value<String> clientId,
      Value<String> vehicleClientId,
      Value<String> label,
      Value<Decimal> cost,
      Value<Decimal> intervalKm,
      Value<int> rowid,
    });

final class $$LocalMaintenanceItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LocalMaintenanceItemsTable,
          LocalMaintenanceItem
        > {
  $$LocalMaintenanceItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalVehiclesTable _vehicleClientIdTable(_$AppDatabase db) =>
      db.localVehicles.createAlias(
        'local_maintenance_items__vehicle_client_id__local_vehicles__client_id',
      );

  $$LocalVehiclesTableProcessedTableManager get vehicleClientId {
    final $_column = $_itemColumn<String>('vehicle_client_id')!;

    final manager = $$LocalVehiclesTableTableManager(
      $_db,
      $_db.localVehicles,
    ).filter((f) => f.clientId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LocalMaintenanceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMaintenanceItemsTable> {
  $$LocalMaintenanceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get cost =>
      $composableBuilder(
        column: $table.cost,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get intervalKm =>
      $composableBuilder(
        column: $table.intervalKm,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$LocalVehiclesTableFilterComposer get vehicleClientId {
    final $$LocalVehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleClientId,
      referencedTable: $db.localVehicles,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalVehiclesTableFilterComposer(
            $db: $db,
            $table: $db.localVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalMaintenanceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMaintenanceItemsTable> {
  $$LocalMaintenanceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intervalKm => $composableBuilder(
    column: $table.intervalKm,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalVehiclesTableOrderingComposer get vehicleClientId {
    final $$LocalVehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleClientId,
      referencedTable: $db.localVehicles,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalVehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.localVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalMaintenanceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMaintenanceItemsTable> {
  $$LocalMaintenanceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get intervalKm =>
      $composableBuilder(
        column: $table.intervalKm,
        builder: (column) => column,
      );

  $$LocalVehiclesTableAnnotationComposer get vehicleClientId {
    final $$LocalVehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleClientId,
      referencedTable: $db.localVehicles,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalVehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.localVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalMaintenanceItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalMaintenanceItemsTable,
          LocalMaintenanceItem,
          $$LocalMaintenanceItemsTableFilterComposer,
          $$LocalMaintenanceItemsTableOrderingComposer,
          $$LocalMaintenanceItemsTableAnnotationComposer,
          $$LocalMaintenanceItemsTableCreateCompanionBuilder,
          $$LocalMaintenanceItemsTableUpdateCompanionBuilder,
          (LocalMaintenanceItem, $$LocalMaintenanceItemsTableReferences),
          LocalMaintenanceItem,
          PrefetchHooks Function({bool vehicleClientId})
        > {
  $$LocalMaintenanceItemsTableTableManager(
    _$AppDatabase db,
    $LocalMaintenanceItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMaintenanceItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalMaintenanceItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalMaintenanceItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<String> vehicleClientId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<Decimal> cost = const Value.absent(),
                Value<Decimal> intervalKm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMaintenanceItemsCompanion(
                clientId: clientId,
                vehicleClientId: vehicleClientId,
                label: label,
                cost: cost,
                intervalKm: intervalKm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                required String vehicleClientId,
                required String label,
                required Decimal cost,
                required Decimal intervalKm,
                Value<int> rowid = const Value.absent(),
              }) => LocalMaintenanceItemsCompanion.insert(
                clientId: clientId,
                vehicleClientId: vehicleClientId,
                label: label,
                cost: cost,
                intervalKm: intervalKm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalMaintenanceItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleClientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vehicleClientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleClientId,
                                referencedTable:
                                    $$LocalMaintenanceItemsTableReferences
                                        ._vehicleClientIdTable(db),
                                referencedColumn:
                                    $$LocalMaintenanceItemsTableReferences
                                        ._vehicleClientIdTable(db)
                                        .clientId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LocalMaintenanceItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalMaintenanceItemsTable,
      LocalMaintenanceItem,
      $$LocalMaintenanceItemsTableFilterComposer,
      $$LocalMaintenanceItemsTableOrderingComposer,
      $$LocalMaintenanceItemsTableAnnotationComposer,
      $$LocalMaintenanceItemsTableCreateCompanionBuilder,
      $$LocalMaintenanceItemsTableUpdateCompanionBuilder,
      (LocalMaintenanceItem, $$LocalMaintenanceItemsTableReferences),
      LocalMaintenanceItem,
      PrefetchHooks Function({bool vehicleClientId})
    >;
typedef $$LocalFixedCostsTableCreateCompanionBuilder =
    LocalFixedCostsCompanion Function({
      required String clientId,
      required String vehicleClientId,
      required String label,
      required Decimal monthlyAmount,
      Value<int> rowid,
    });
typedef $$LocalFixedCostsTableUpdateCompanionBuilder =
    LocalFixedCostsCompanion Function({
      Value<String> clientId,
      Value<String> vehicleClientId,
      Value<String> label,
      Value<Decimal> monthlyAmount,
      Value<int> rowid,
    });

final class $$LocalFixedCostsTableReferences
    extends
        BaseReferences<_$AppDatabase, $LocalFixedCostsTable, LocalFixedCost> {
  $$LocalFixedCostsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalVehiclesTable _vehicleClientIdTable(_$AppDatabase db) =>
      db.localVehicles.createAlias(
        'local_fixed_costs__vehicle_client_id__local_vehicles__client_id',
      );

  $$LocalVehiclesTableProcessedTableManager get vehicleClientId {
    final $_column = $_itemColumn<String>('vehicle_client_id')!;

    final manager = $$LocalVehiclesTableTableManager(
      $_db,
      $_db.localVehicles,
    ).filter((f) => f.clientId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LocalFixedCostsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalFixedCostsTable> {
  $$LocalFixedCostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get monthlyAmount =>
      $composableBuilder(
        column: $table.monthlyAmount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$LocalVehiclesTableFilterComposer get vehicleClientId {
    final $$LocalVehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleClientId,
      referencedTable: $db.localVehicles,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalVehiclesTableFilterComposer(
            $db: $db,
            $table: $db.localVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalFixedCostsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalFixedCostsTable> {
  $$LocalFixedCostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get monthlyAmount => $composableBuilder(
    column: $table.monthlyAmount,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalVehiclesTableOrderingComposer get vehicleClientId {
    final $$LocalVehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleClientId,
      referencedTable: $db.localVehicles,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalVehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.localVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalFixedCostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalFixedCostsTable> {
  $$LocalFixedCostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get monthlyAmount =>
      $composableBuilder(
        column: $table.monthlyAmount,
        builder: (column) => column,
      );

  $$LocalVehiclesTableAnnotationComposer get vehicleClientId {
    final $$LocalVehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleClientId,
      referencedTable: $db.localVehicles,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalVehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.localVehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalFixedCostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalFixedCostsTable,
          LocalFixedCost,
          $$LocalFixedCostsTableFilterComposer,
          $$LocalFixedCostsTableOrderingComposer,
          $$LocalFixedCostsTableAnnotationComposer,
          $$LocalFixedCostsTableCreateCompanionBuilder,
          $$LocalFixedCostsTableUpdateCompanionBuilder,
          (LocalFixedCost, $$LocalFixedCostsTableReferences),
          LocalFixedCost,
          PrefetchHooks Function({bool vehicleClientId})
        > {
  $$LocalFixedCostsTableTableManager(
    _$AppDatabase db,
    $LocalFixedCostsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalFixedCostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalFixedCostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalFixedCostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<String> vehicleClientId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<Decimal> monthlyAmount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFixedCostsCompanion(
                clientId: clientId,
                vehicleClientId: vehicleClientId,
                label: label,
                monthlyAmount: monthlyAmount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                required String vehicleClientId,
                required String label,
                required Decimal monthlyAmount,
                Value<int> rowid = const Value.absent(),
              }) => LocalFixedCostsCompanion.insert(
                clientId: clientId,
                vehicleClientId: vehicleClientId,
                label: label,
                monthlyAmount: monthlyAmount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalFixedCostsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleClientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vehicleClientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleClientId,
                                referencedTable:
                                    $$LocalFixedCostsTableReferences
                                        ._vehicleClientIdTable(db),
                                referencedColumn:
                                    $$LocalFixedCostsTableReferences
                                        ._vehicleClientIdTable(db)
                                        .clientId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LocalFixedCostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalFixedCostsTable,
      LocalFixedCost,
      $$LocalFixedCostsTableFilterComposer,
      $$LocalFixedCostsTableOrderingComposer,
      $$LocalFixedCostsTableAnnotationComposer,
      $$LocalFixedCostsTableCreateCompanionBuilder,
      $$LocalFixedCostsTableUpdateCompanionBuilder,
      (LocalFixedCost, $$LocalFixedCostsTableReferences),
      LocalFixedCost,
      PrefetchHooks Function({bool vehicleClientId})
    >;
typedef $$LocalWorkProfilesTableCreateCompanionBuilder =
    LocalWorkProfilesCompanion Function({
      required String clientId,
      required String name,
      Value<String?> vehicleClientId,
      required Decimal goalRsPerKm,
      required Decimal goalRsPerHour,
      required double minPassengerRating,
      required Decimal maxPickupKm,
      required Decimal dailyRevenueGoal,
      required Decimal monthlyRevenueGoal,
      required Decimal thinkTolerancePercent,
      required Decimal targetMarginPercent,
      Value<bool> isActive,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$LocalWorkProfilesTableUpdateCompanionBuilder =
    LocalWorkProfilesCompanion Function({
      Value<String> clientId,
      Value<String> name,
      Value<String?> vehicleClientId,
      Value<Decimal> goalRsPerKm,
      Value<Decimal> goalRsPerHour,
      Value<double> minPassengerRating,
      Value<Decimal> maxPickupKm,
      Value<Decimal> dailyRevenueGoal,
      Value<Decimal> monthlyRevenueGoal,
      Value<Decimal> thinkTolerancePercent,
      Value<Decimal> targetMarginPercent,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$LocalWorkProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalWorkProfilesTable> {
  $$LocalWorkProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleClientId => $composableBuilder(
    column: $table.vehicleClientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get goalRsPerKm =>
      $composableBuilder(
        column: $table.goalRsPerKm,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get goalRsPerHour =>
      $composableBuilder(
        column: $table.goalRsPerHour,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get minPassengerRating => $composableBuilder(
    column: $table.minPassengerRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get maxPickupKm =>
      $composableBuilder(
        column: $table.maxPickupKm,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String>
  get dailyRevenueGoal => $composableBuilder(
    column: $table.dailyRevenueGoal,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String>
  get monthlyRevenueGoal => $composableBuilder(
    column: $table.monthlyRevenueGoal,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String>
  get thinkTolerancePercent => $composableBuilder(
    column: $table.thinkTolerancePercent,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String>
  get targetMarginPercent => $composableBuilder(
    column: $table.targetMarginPercent,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalWorkProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalWorkProfilesTable> {
  $$LocalWorkProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleClientId => $composableBuilder(
    column: $table.vehicleClientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalRsPerKm => $composableBuilder(
    column: $table.goalRsPerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalRsPerHour => $composableBuilder(
    column: $table.goalRsPerHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minPassengerRating => $composableBuilder(
    column: $table.minPassengerRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maxPickupKm => $composableBuilder(
    column: $table.maxPickupKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dailyRevenueGoal => $composableBuilder(
    column: $table.dailyRevenueGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get monthlyRevenueGoal => $composableBuilder(
    column: $table.monthlyRevenueGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thinkTolerancePercent => $composableBuilder(
    column: $table.thinkTolerancePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetMarginPercent => $composableBuilder(
    column: $table.targetMarginPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalWorkProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalWorkProfilesTable> {
  $$LocalWorkProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get vehicleClientId => $composableBuilder(
    column: $table.vehicleClientId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Decimal, String> get goalRsPerKm =>
      $composableBuilder(
        column: $table.goalRsPerKm,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal, String> get goalRsPerHour =>
      $composableBuilder(
        column: $table.goalRsPerHour,
        builder: (column) => column,
      );

  GeneratedColumn<double> get minPassengerRating => $composableBuilder(
    column: $table.minPassengerRating,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Decimal, String> get maxPickupKm =>
      $composableBuilder(
        column: $table.maxPickupKm,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal, String> get dailyRevenueGoal =>
      $composableBuilder(
        column: $table.dailyRevenueGoal,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal, String> get monthlyRevenueGoal =>
      $composableBuilder(
        column: $table.monthlyRevenueGoal,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal, String> get thinkTolerancePercent =>
      $composableBuilder(
        column: $table.thinkTolerancePercent,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Decimal, String> get targetMarginPercent =>
      $composableBuilder(
        column: $table.targetMarginPercent,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$LocalWorkProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalWorkProfilesTable,
          LocalWorkProfile,
          $$LocalWorkProfilesTableFilterComposer,
          $$LocalWorkProfilesTableOrderingComposer,
          $$LocalWorkProfilesTableAnnotationComposer,
          $$LocalWorkProfilesTableCreateCompanionBuilder,
          $$LocalWorkProfilesTableUpdateCompanionBuilder,
          (
            LocalWorkProfile,
            BaseReferences<
              _$AppDatabase,
              $LocalWorkProfilesTable,
              LocalWorkProfile
            >,
          ),
          LocalWorkProfile,
          PrefetchHooks Function()
        > {
  $$LocalWorkProfilesTableTableManager(
    _$AppDatabase db,
    $LocalWorkProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalWorkProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalWorkProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalWorkProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> vehicleClientId = const Value.absent(),
                Value<Decimal> goalRsPerKm = const Value.absent(),
                Value<Decimal> goalRsPerHour = const Value.absent(),
                Value<double> minPassengerRating = const Value.absent(),
                Value<Decimal> maxPickupKm = const Value.absent(),
                Value<Decimal> dailyRevenueGoal = const Value.absent(),
                Value<Decimal> monthlyRevenueGoal = const Value.absent(),
                Value<Decimal> thinkTolerancePercent = const Value.absent(),
                Value<Decimal> targetMarginPercent = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWorkProfilesCompanion(
                clientId: clientId,
                name: name,
                vehicleClientId: vehicleClientId,
                goalRsPerKm: goalRsPerKm,
                goalRsPerHour: goalRsPerHour,
                minPassengerRating: minPassengerRating,
                maxPickupKm: maxPickupKm,
                dailyRevenueGoal: dailyRevenueGoal,
                monthlyRevenueGoal: monthlyRevenueGoal,
                thinkTolerancePercent: thinkTolerancePercent,
                targetMarginPercent: targetMarginPercent,
                isActive: isActive,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                required String name,
                Value<String?> vehicleClientId = const Value.absent(),
                required Decimal goalRsPerKm,
                required Decimal goalRsPerHour,
                required double minPassengerRating,
                required Decimal maxPickupKm,
                required Decimal dailyRevenueGoal,
                required Decimal monthlyRevenueGoal,
                required Decimal thinkTolerancePercent,
                required Decimal targetMarginPercent,
                Value<bool> isActive = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWorkProfilesCompanion.insert(
                clientId: clientId,
                name: name,
                vehicleClientId: vehicleClientId,
                goalRsPerKm: goalRsPerKm,
                goalRsPerHour: goalRsPerHour,
                minPassengerRating: minPassengerRating,
                maxPickupKm: maxPickupKm,
                dailyRevenueGoal: dailyRevenueGoal,
                monthlyRevenueGoal: monthlyRevenueGoal,
                thinkTolerancePercent: thinkTolerancePercent,
                targetMarginPercent: targetMarginPercent,
                isActive: isActive,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalWorkProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalWorkProfilesTable,
      LocalWorkProfile,
      $$LocalWorkProfilesTableFilterComposer,
      $$LocalWorkProfilesTableOrderingComposer,
      $$LocalWorkProfilesTableAnnotationComposer,
      $$LocalWorkProfilesTableCreateCompanionBuilder,
      $$LocalWorkProfilesTableUpdateCompanionBuilder,
      (
        LocalWorkProfile,
        BaseReferences<
          _$AppDatabase,
          $LocalWorkProfilesTable,
          LocalWorkProfile
        >,
      ),
      LocalWorkProfile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalRideEvaluationsTableTableManager get localRideEvaluations =>
      $$LocalRideEvaluationsTableTableManager(_db, _db.localRideEvaluations);
  $$LocalExpensesTableTableManager get localExpenses =>
      $$LocalExpensesTableTableManager(_db, _db.localExpenses);
  $$LocalWorkSessionsTableTableManager get localWorkSessions =>
      $$LocalWorkSessionsTableTableManager(_db, _db.localWorkSessions);
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
  $$LocalVehiclesTableTableManager get localVehicles =>
      $$LocalVehiclesTableTableManager(_db, _db.localVehicles);
  $$LocalMaintenanceItemsTableTableManager get localMaintenanceItems =>
      $$LocalMaintenanceItemsTableTableManager(_db, _db.localMaintenanceItems);
  $$LocalFixedCostsTableTableManager get localFixedCosts =>
      $$LocalFixedCostsTableTableManager(_db, _db.localFixedCosts);
  $$LocalWorkProfilesTableTableManager get localWorkProfiles =>
      $$LocalWorkProfilesTableTableManager(_db, _db.localWorkProfiles);
}
