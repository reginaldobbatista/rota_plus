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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalRideEvaluationsTable localRideEvaluations =
      $LocalRideEvaluationsTable(this);
  late final $LocalExpensesTable localExpenses = $LocalExpensesTable(this);
  late final $LocalWorkSessionsTable localWorkSessions =
      $LocalWorkSessionsTable(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final RideDao rideDao = RideDao(this as AppDatabase);
  late final ExpenseDao expenseDao = ExpenseDao(this as AppDatabase);
  late final OutboxDao outboxDao = OutboxDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localRideEvaluations,
    localExpenses,
    localWorkSessions,
    outboxEntries,
  ];
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
}
